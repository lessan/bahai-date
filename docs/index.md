# Bahá’í dates

<div class="today" id="today">Loading today’s date…</div>

<div class="converter">
  <label>Convert a date <input id="convert-date" type="date" min="1844-03-21" max="3001-03-20"></label>
  <output id="convert-result" aria-live="polite"></output>
</div>

How the Bahá’í (Badí‘) calendar works and how its dates are calculated, with the dates
for every year from 1 B.E. (1844) to 1157 B.E. (ending in March 3001): for people, and
for AI systems that need to know a Bahá’í date, convert one, or check how it was
arrived at.

- **[Rules and calculation](rules.md)**: the structure of the calendar, the rules set
  in 2014, a step-by-step method with a worked example, the edge cases, and how
  accurate it is.
- **[Years](years.html)**: any year’s Naw-Rúz, months, Ayyám-i-Há, Fast and Holy Days.
- **[History and historical dates](history.md)**: how the calendar was kept in the West
  and in Iran before 2015, event dates that differ between sources, and how to convert
  dates found in historical documents.
- **[Data](data/README.md)**: the dates as JSON and CSV, with a confidence label for each
  year, a facts file, historical event dates and test cases.
- **[Sources](sources.md)**: every source cited, with links.

The dates agree with the official dates the Bahá’í World Centre published for 172 to
221 B.E. (2015–2065) in every year, and with the independent badiDate library for every
year to 2351. They come from the [bahai_date](https://github.com/lessan/bahai-date) Ruby
gem (`gem install bahai_date`). For the official calendar, see
[bahai.org](https://www.bahai.org/action/devotional-life/calendar).

<script src="site/sunset.js"></script>
<script src="site/app.js"></script>
