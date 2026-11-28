# Years

<div class="controls">
  <button id="prev" type="button" aria-label="Previous year">←</button>
  <label>Year B.E. <input id="year" type="number" min="1" max="1157" inputmode="numeric"></label>
  <span>or</span>
  <label>Gregorian year of Naw-Rúz <input id="gregorian" type="number" min="1844" max="3000" inputmode="numeric"></label>
  <button id="show" type="button">Show</button>
  <button id="next" type="button" aria-label="Next year">→</button>
</div>

<div id="year-view">Loading…</div>

<noscript>This page needs JavaScript. The same dates are in the <a href="data/years.csv">years CSV</a> and one JSON file per year, such as <a href="data/years/183.json">data/years/183.json</a>.</noscript>

Years before 172 B.E. follow the Western convention, and years after 507 B.E. are
estimates; see [accuracy and limits](rules.md#accuracy-and-limits) and
[history](history.md).

<script src="site/app.js"></script>
