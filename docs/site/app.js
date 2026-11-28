// Reads the per-year files in data/years/ to show today's date and browse years.
// Dates are handled as UTC calendar days so the reader's time zone cannot shift them.
"use strict";

const DAY = 86400000;
const MAX_YEAR = 1157;
const WEEKDAYS = ["Jamál", "Kamál", "Fiḍál", "‘Idál", "Istijlál", "Istiqlál", "Jalál"]; // Sunday first, as Date.getUTCDay

const root = document.currentScript.dataset.root || "";
const cache = new Map();

function parse(iso) { const [y, m, d] = iso.split("-").map(Number); return Date.UTC(y, m - 1, d); }
function iso(ms) { return new Date(ms).toISOString().slice(0, 10); }
function pretty(ms) {
  return new Date(ms).toLocaleDateString("en-GB", { weekday: "long", day: "numeric", month: "long", year: "numeric", timeZone: "UTC" });
}
function escape(s) { return String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]); }

async function loadYear(year) {
  if (year < 1 || year > MAX_YEAR) return null;
  if (!cache.has(year)) {
    cache.set(year, fetch(`${root}data/years/${year}.json`).then((r) => (r.ok ? r.json() : null)));
  }
  return cache.get(year);
}

// The Bahá’í date of the day that ends at sunset on the given Gregorian date.
async function badiDate(ms) {
  const g = new Date(ms).getUTCFullYear();
  let data = await loadYear(g - 1843);
  if (!data || ms < parse(data.nawruz)) data = await loadYear(g - 1844);
  if (!data) return null;
  const offset = Math.round((ms - parse(data.nawruz)) / DAY);
  const ayyam = data.ayyam_i_ha.days;
  let month, day, monthName;
  if (offset < 342) {
    month = Math.floor(offset / 19) + 1;
    day = (offset % 19) + 1;
  } else if (offset < 342 + ayyam) {
    month = 0;
    day = offset - 342 + 1;
  } else {
    month = 19;
    day = offset - 342 - ayyam + 1;
  }
  monthName = month === 0 ? "Ayyám-i-Há" : data.months[month - 1].name;
  const holy = data.holy_days.filter((h) => h.date === iso(ms)).map((h) => h.name);
  return { data, month, day, monthName, holy, weekday: WEEKDAYS[new Date(ms).getUTCDay()] };
}

function describe(b) {
  const where = b.month === 0 ? `${b.day} Ayyám-i-Há` : `${b.day} ${b.monthName}`;
  return `${b.weekday}, ${where} ${b.data.year} B.E.`;
}

async function showToday(el) {
  const now = new Date();
  const today = Date.UTC(now.getFullYear(), now.getMonth(), now.getDate());
  const [before, after] = await Promise.all([badiDate(today), badiDate(today + DAY)]);
  if (!before) { el.textContent = "Today is outside the years this site covers."; return; }
  const holy = (b) => (b && b.holy.length ? ` — ${escape(b.holy.join(", "))}` : "");
  el.innerHTML = `
    <div class="muted">Until sunset today, ${escape(pretty(today))}:</div>
    <div class="date">${escape(describe(before))}${holy(before)}</div>
    ${after ? `<div class="muted" style="margin-top:.5rem">From sunset this evening: ${escape(describe(after))}${holy(after)}</div>` : ""}
    <div class="note">Sunset depends on where you are; this page uses your device’s date and does not know your sunset time.</div>`;
}

async function showYear(el, year) {
  const data = await loadYear(year);
  if (!data) { el.innerHTML = `<p>Years 1 to ${MAX_YEAR} B.E. are covered.</p>`; return; }
  const conf = { convention: "convention", published: "published", "cross-checked": "cross-checked", estimate: "estimate" }[data.confidence];
  const rows = (items, cells) => items.map((x) => `<tr>${cells(x).map((c) => `<td>${c}</td>`).join("")}</tr>`).join("");
  const day = (s) => escape(pretty(parse(s)));
  el.innerHTML = `
    <h2>${data.year} B.E. <span class="label">${escape(conf)}</span></h2>
    <p>Year ${data.year_in_vahid} of Váḥid ${data.vahid}, Kull-i-Shay’ ${data.kull_i_shay}: <strong>${escape(data.year_name)}</strong> (${escape(data.year_translation)}).
    ${data.days_in_year} days, from Naw-Rúz on ${day(data.nawruz)}.</p>
    <p>Ayyám-i-Há: ${day(data.ayyam_i_ha.first)} to ${day(data.ayyam_i_ha.last)} (${data.ayyam_i_ha.days} days).
    The Fast: ${day(data.fast.first)} to ${day(data.fast.last)}.</p>
    <h3>Holy Days</h3>
    <table><thead><tr><th>Holy Day</th><th>Bahá’í date</th><th>Gregorian date</th><th>Work suspended</th></tr></thead>
    <tbody>${rows(data.holy_days, (h) => [escape(h.name), `${h.day} ${escape(data.months[h.month - 1].name)}`, day(h.date), h.work_suspended ? "yes" : "no"])}</tbody></table>
    <h3>Months (Nineteen Day Feasts)</h3>
    <table><thead><tr><th></th><th>Month</th><th>First day</th></tr></thead>
    <tbody>${rows(data.months, (m) => [m.number, `${escape(m.name)} <span class="muted">(${escape(m.translation)})</span>`, day(m.first_day)])}</tbody></table>
    <p class="muted">Each date is the day on which the Bahá’í day ends; it begins at sunset the evening before.
    <a href="${root}data/years/${data.year}.json">This year as JSON</a>.</p>`;
}

function setUpYears(el) {
  const input = document.getElementById("year");
  const go = (y) => {
    y = Math.min(MAX_YEAR, Math.max(1, Number(y) || 1));
    input.value = y;
    history.replaceState(null, "", `?year=${y}`);
    showYear(el, y);
  };
  document.getElementById("prev").onclick = () => go(Number(input.value) - 1);
  document.getElementById("next").onclick = () => go(Number(input.value) + 1);
  document.getElementById("show").onclick = () => go(input.value);
  input.addEventListener("keydown", (e) => { if (e.key === "Enter") go(input.value); });
  document.getElementById("gregorian").addEventListener("keydown", async (e) => {
    if (e.key !== "Enter") return;
    const g = Number(e.target.value);
    if (g) go(g - 1843);
  });
  const param = Number(new URLSearchParams(location.search).get("year"));
  if (param) go(param);
  else badiDate(Date.UTC(new Date().getFullYear(), new Date().getMonth(), new Date().getDate())).then((b) => go(b ? b.data.year : 183));
}

const todayEl = document.getElementById("today");
if (todayEl) showToday(todayEl);
const yearEl = document.getElementById("year-view");
if (yearEl) setUpYears(yearEl);
