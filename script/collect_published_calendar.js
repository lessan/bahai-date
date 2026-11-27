#!/usr/bin/env node
// Collects the Bahá'í calendar that bahai.org renders, for every year its
// year-selector offers, into the JSON that spec/bahai_date/published_calendar_spec.rb
// checks this gem against.
//
//   npm install puppeteer            # not a dependency of the gem
//   node script/collect_published_calendar.js > spec/fixtures/bahai_org_calendar.json
//
// CHROME_PATH overrides the browser binary.
//
// The page is a Gatsby build: only the default year is server-rendered, and the
// year is React state behind a <select>, so this drives a real browser. Class
// names are styled-components hashes that change on every deploy, so everything
// below is matched on structure and text, not on class names.

const puppeteer = require("puppeteer");

const URL = "https://www.bahai.org/action/devotional-life/calendar";
const CHROME_PATH = process.env.CHROME_PATH || undefined;

const MONTHS = {
  January: "01", February: "02", March: "03", April: "04", May: "05", June: "06",
  July: "07", August: "08", September: "09", October: "10", November: "11", December: "12"
};

const DATE = String.raw`\d{1,2} [A-Z][a-z]+ \d{4}`;
// Dates as the page writes them: "21 March 2026", "26 February–1 March 2027"
// (the year is only on the last one), "2–20 March 2027".
const DATE_OR_RANGE = String.raw`\d{1,2}(?: [A-Z][a-z]+)?(?:–\d{1,2}(?: [A-Z][a-z]+)?)? \d{4}`;

function iso(day, month, year) {
  return `${year}-${MONTHS[month]}-${String(day).padStart(2, "0")}`;
}

function parseDate(text) {
  const m = text.match(/^(\d{1,2}) ([A-Z][a-z]+) (\d{4})$/);
  if (!m) throw new Error(`unparseable date: ${text}`);
  return iso(m[1], m[2], m[3]);
}

// "26 February–1 March 2027" and "2–20 March 2027". The first date has no year,
// so infer it: within a year it comes before the second date, otherwise it is
// the previous year (a range never crosses more than one year end here).
function parseRange(text) {
  const full = text.match(/^(\d{1,2}) ([A-Z][a-z]+)–(\d{1,2}) ([A-Z][a-z]+) (\d{4})$/);
  if (full) {
    const [, d1, m1, d2, m2, y2] = full;
    const y1 = MONTHS[m1] > MONTHS[m2] ? Number(y2) - 1 : Number(y2);
    return { startDate: iso(d1, m1, y1), endDate: iso(d2, m2, y2) };
  }

  const sameMonth = text.match(/^(\d{1,2})–(\d{1,2}) ([A-Z][a-z]+) (\d{4})$/);
  if (sameMonth) {
    const [, d1, d2, m, y] = sameMonth;
    return { startDate: iso(d1, m, y), endDate: iso(d2, m, y) };
  }

  const single = parseDate(text);
  return { startDate: single, endDate: single };
}

function collect(page) {
  return page.evaluate((DATE_SRC) => {
    const norm = (s) => s.replace(/\s+/g, " ").trim();
    const re = new RegExp(`^${DATE_SRC}$`);

    // The year selector sits above the calendar; the prose above it also cites
    // a date ("The Universal House of Justice, 10 July 2014"), so ignore
    // anything that comes before it in the document.
    const select = [...document.querySelectorAll("select")].find((s) =>
      [...s.options].some((o) => /B\.E\./.test(o.textContent))
    );
    if (!select) throw new Error("year selector not found");

    // Every dated row is [title...][date] under one element, and the date is a
    // leaf, so the grandparent's text is "<title blob><date>".
    const rows = [...document.querySelectorAll("div")]
      .filter((el) => el.children.length === 0 && re.test(norm(el.textContent)))
      .filter(
        (el) => select.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING
      )
      .map((el) => {
        const row = el.parentElement.parentElement;
        const text = norm(row.textContent);
        const date = norm(el.textContent);
        if (!text.endsWith(date)) return null;

        // Month rows look like "11.1MashíyyatWill27 September 2026": the
        // transliteration is the only <p>, the month number leads the row.
        const name = row.querySelector("p");
        const number = text.match(/^(\d{1,2})\.\d/);

        return {
          rowText: text,
          date,
          monthNumber: number ? Number(number[1]) : null,
          hasName: Boolean(name),
          name: name ? norm(name.textContent) : null
        };
      })
      .filter(Boolean);

    const option = select.options[select.selectedIndex];
    const era = option.textContent.match(/(\d{3})\s*B\.E\./);

    return {
      calendarYearStart: Number(select.value),
      bahaiEra: era ? Number(era[1]) : null,
      rows
    };
  }, DATE_OR_RANGE);
}

(async () => {
  const launch = { headless: true };
  if (CHROME_PATH) launch.executablePath = CHROME_PATH;

  const browser = await puppeteer.launch(launch);
  const page = await browser.newPage();
  await page.goto(URL, { waitUntil: "networkidle2" });

  const years = await page.evaluate(() => {
    const select = [...document.querySelectorAll("select")].find((s) =>
      [...s.options].some((o) => /B\.E\./.test(o.textContent))
    );
    if (!select) throw new Error("year selector not found");
    return [...select.options].map((o) => Number(o.value));
  });
  if (years.length === 0) throw new Error("year selector has no options");

  const eras = [];
  for (const year of years) {
    await page.select("select", String(year));
    // Re-render is synchronous but wait for the first month's date to catch up.
    await page.waitForFunction(
      (y, dateSrc) => {
        const re = new RegExp(`^${dateSrc}$`);
        const norm = (s) => s.replace(/\s+/g, " ").trim();
        const first = [...document.querySelectorAll("div")].find(
          (el) => el.children.length === 0 && re.test(norm(el.textContent)) && norm(el.textContent).endsWith(`March ${y}`)
        );
        return Boolean(first);
      },
      { timeout: 20000 },
      year,
      DATE
    );

    const { bahaiEra, calendarYearStart, rows } = await collect(page);
    if (bahaiEra !== calendarYearStart - 1843) {
      throw new Error(`era ${bahaiEra} does not match year ${calendarYearStart}`);
    }

    // Nothing the page lists for an era may fall outside its two Gregorian
    // years (the era starts in March of calendarYearStart and ends in March of
    // the next one).
    const outside = rows.filter((r) => {
      const years = [...r.date.matchAll(/(\d{4})/g)].map((m) => Number(m[1]));
      return years.some((y) => y !== calendarYearStart && y !== calendarYearStart + 1);
    });
    if (outside.length > 0) {
      throw new Error(`era ${bahaiEra}: dates outside the era: ${outside.map((r) => r.date).join(", ")}`);
    }

    const monthRows = rows.filter((r) => r.monthNumber && r.hasName && !/–/.test(r.date));
    const ayyamRow = rows.find((r) => /Ayyám-i-Há/.test(r.rowText));
    const monthStarts = rows.filter((r) => /^(\d{1,2})\.\d.*\d{1,2} [A-Z][a-z]+ \d{4}$/.test(r.rowText) && !/–/.test(r.date));

    // After the last month row come "Bahá’í Holy Days" and "Significant Dates",
    // which are title/date rows. Splitting by position rather than by date:
    // in six eras a Twin Birthday falls on the first day of a month, so
    // removing rows whose date is already a month start loses them.
    const lastMonthIndex = rows.lastIndexOf(monthStarts[monthStarts.length - 1]);
    const others = rows.slice(lastMonthIndex + 1);

    if (monthStarts.length !== 19) throw new Error(`era ${bahaiEra}: ${monthStarts.length} month starts`);
    if (!ayyamRow) throw new Error(`era ${bahaiEra}: no Ayyám-i-Há row`);
    if (others.length !== 12) {
      throw new Error(`era ${bahaiEra}: ${others.length} holy/significant dates, expected 12`);
    }

    const monthNumbers = monthStarts.map((r) => r.monthNumber);
    if (monthNumbers.join(",") !== Array.from({ length: 19 }, (_, i) => i + 1).join(",")) {
      throw new Error(`era ${bahaiEra}: month numbers ${monthNumbers.join(",")}`);
    }

    eras.push({
      bahaiEra,
      calendarYearStart,
      months: monthStarts.map((r) => ({
        number: r.monthNumber,
        name: r.name,
        startDate: parseDate(r.date)
      })),
      ayyamIHa: parseRange(ayyamRow.date),
      dates: others.map((r) => ({
        title: r.rowText.slice(0, r.rowText.length - r.date.length),
        ...parseRange(r.date)
      }))
    });

    if (monthRows.length !== 19) throw new Error(`era ${bahaiEra}: ${monthRows.length} named month rows`);
    process.stderr.write(`era ${bahaiEra} (${calendarYearStart}): ${others.length} holy/significant dates\n`);
  }

  await browser.close();

  const out = {
    source: {
      url: URL,
      retrievedAt: new Date().toISOString(),
      note: "Rendered month starts, Ayyám-i-Há and holy/significant dates for every year the page's selector offers. Collected by script/collect_published_calendar.js."
    },
    eras
  };
  process.stdout.write(JSON.stringify(out, null, 1) + "\n");
})();
