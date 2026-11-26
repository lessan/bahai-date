# Changelog

## 2.0.0

Breaking changes:
- `BahaiDate.new` takes keyword arguments only. Pass `date:`, or `year:`,
  `month:` and `day:`; a positional options hash is no longer accepted.
- Requires Ruby 3.3 or newer (tested on 3.3, 3.4 and 4.0), and tzinfo 2.x.

Other changes:
- The astronomical algorithms from `astro-algo` now live in
  `lib/bahai_date/astro.rb` as `BahaiDate::Astro`. Its only published release
  does not work on modern Ruby and the gem is unmaintained, and it used to
  reopen `Numeric`, `Array` and `DateTime` on load; it no longer does.
- `bigdecimal`, a bundled gem since Ruby 3.4, is now declared as a dependency.
- Removed `require "bundler/setup"` from the library.
- `Month#add_day` returns the existing day instead of `nil` when called twice.
- `OccasionFactory.find` returns `nil` for an unknown occasion instead of
  raising `NoMethodError`.
- Naw-Ruz dates are memoised per year, which makes converting runs of dates
  (and building a `YearCalendar`) far cheaper.
- The specs check every published month start, Ayyam-i-Ha range, holy day and
  significant date for eras 172-221 against bahai.org itself. Refresh the data
  with `script/collect_published_calendar.js`.
