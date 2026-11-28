# Changelog

## 2.0.1

- Documentation of the calendar's rules and how its dates are calculated
  (`docs/calendar-rules.md`), and a dataset of every year from 1 to 1157 B.E.
  (`docs/data/`), published at https://lessan.github.io/bahai-date/.
- The specs check the gem against Table A of the official *Bahá’í Dates 172 to
  221 B.E.*
- `Sunset.utc` puts sunset on the right UTC day far from Greenwich. It used to
  return a time 24 hours early west of about 90°W (the Americas), where sunset
  falls after midnight UTC. Tehran, and so the calendar, was never affected.
- The gem package contains only `lib/` and the documents, not the specs.

## 2.0.0

Breaking changes:
- `BahaiDate.new` takes keyword arguments only. Pass `date:`, or `year:`,
  `month:` and `day:`; a positional options hash is no longer accepted.
- Requires Ruby 3.3 or newer (tested on 3.3, 3.4 and 4.0).
- Years are limited to 1 to 1157 B.E., and Gregorian dates to the end of 1157
  B.E. (March 3001), the range the astronomical algorithms are good for. Out
  of range years raise `ArgumentError` from `BahaiDate.new`, `Year.new`,
  `YearCalendar.new`, `Logic` and `OccasionFactory`. Before, very large years
  were accepted and gave wrong dates or misleading errors.
- `Year#translation` for the 18th and 19th years of a Vahid now gives "Most
  Luminous" and "Unity". It gave "Most" and "Luminous", because "Most
  Luminous" was split in two.
- The Ayyam-i-Ha occasion titles say "Intercalary", not "Intercalery".

Other changes:
- `BahaiDate.new(date:)` accepts anything with `to_date`, such as a `Time` or
  `DateTime`, and `gregorian_date` is then always a `Date`. Anything else
  raises `ArgumentError`. Note that a Baha'i day begins at sunset, while this
  gem converts whole Gregorian dates.
- No runtime dependencies. The sunset algorithm from `RubySunrise` now
  lives in `lib/bahai_date/sunset.rb` as `BahaiDate::Sunset`, which removes
  `RubySunrise`, `tzinfo` and `bigdecimal`. Tehran time is a fixed UTC+03:30,
  which gives the same dates as the Asia/Tehran zone for every year from 2015
  to 3001, so no system time zone data is needed. `Logic::TEHRAN_LAT` and
  `Logic::TEHRAN_LONG` are now Floats rather than BigDecimals. Naw-Ruz and the
  Twin Holy Days are unchanged for every year from 2015 to 3001.
- The gemspec sets `rubygems_mfa_required`, so a release can only be pushed
  with multi-factor authentication, and links to the source, changelog and
  issues.
- The astronomical algorithms from `astro-algo` now live in
  `lib/bahai_date/astro.rb` as `BahaiDate::Astro`. Its only published release
  does not work on modern Ruby and the gem is unmaintained, and it used to
  reopen `Numeric`, `Array` and `DateTime` on load; it no longer does.
- Removed `require "bundler/setup"` from the library.
- `Month#add_day` returns the existing day instead of `nil` when called twice.
- `OccasionFactory.find` returns `nil` for an unknown occasion instead of
  raising `NoMethodError`.
- Naw-Ruz dates are memoised per year, which makes converting runs of dates
  (and building a `YearCalendar`) far cheaper.
- The specs check every published month start, Ayyam-i-Ha range, holy day and
  significant date for eras 172-221 against bahai.org itself. Refresh the data
  with `script/collect_published_calendar.js`. They also check Naw-Ruz, the
  Twin Holy Days and Ayyam-i-Ha against the badiDate JavaScript library for
  172-507 (2015-2351), and agree on every year.
