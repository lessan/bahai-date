#!/usr/bin/env ruby
# Writes the dates dataset in docs/data/ from this gem:
#
#   bundle exec ruby script/generate_data.rb
#
# spec/data_spec.rb fails if the files no longer match what the gem computes,
# so re-run this after any change to the calculations. events.json, the JSON
# Schema and README.md in docs/data/ are written by hand and left alone.

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bahai_date"
require "csv"
require "fileutils"
require "json"

module DataExport
  OUT = File.expand_path("../docs/data", __dir__)
  SITE = "https://lessan.github.io/bahai-date"

  # How far each range of years can be trusted. See docs/rules.md.
  CONFIDENCE = [
    [1..66, "convention-proleptic", "The Western convention set out under Shoghi Effendi (Naw-Rúz on 21 March, the Twin Holy Days on 20 October and 12 November), applied to years before any Western Bahá’í community kept the calendar (its first attested use in the West is 1910). Bahá’ís in Iran reckoned differently: see eastern_reconstruction and #{SITE}/history.html."],
    [67..171, "convention", "The Western convention set out under Shoghi Effendi (Naw-Rúz on 21 March, the Twin Holy Days on 20 October and 12 November), as kept in the West. Bahá’ís in Iran reckoned differently: see eastern_reconstruction and #{SITE}/history.html."],
    [172..221, "published", "Matches the dates published by the Bahá’í World Centre for 172 to 221 B.E."],
    [222..507, "cross-checked", "Computed; agrees with the independent badiDate library (JPL ephemeris) for every year to 2351."],
    [508..BahaiDate::Year::MAX, "estimate", "Computed; the uncertainty in the Earth's rotation (Delta T) means some years may be a day out where the equinox falls close to sunset in Ṭihrán."]
  ].freeze

  STATUSES = {
    "observed" => "An anniversary or festival kept in this year.",
    "event-year" => "The year of the event itself. The date shown follows the calendar convention for the year and may differ by a day from the date of the event in the historical sources: see events.json.",
    "proleptic" => "After the event but before its first known observance: the Day of the Covenant before 1901."
  }.freeze

  # The Day of the Covenant was appointed by ‘Abdu’l-Bahá after 1892; its first
  # known observance, in the West, is 1901 (58 B.E.).
  COVENANT_FIRST_KNOWN = 58

  # The equinox within this many minutes of sunset in Ṭihrán makes a
  # reconstructed Naw-Rúz uncertain.
  UNCERTAIN_MINUTES = 15

  HOLY_DAYS = %i[nawruz ridvan_1 ridvan_9 ridvan_12 declaration_bab ascension_bahaullah martyrdom_bab
    birth_bab birth_bahaullah covenant ascension_abdulbaha].freeze

  # Hours at which Holy Days are commemorated, with the source ids of docs/sources.md.
  COMMEMORATION = {
    ridvan_1: ["Late in the afternoon (about 3 p.m.)", %w[aqdas walbridge-1996]],
    declaration_bab: ["2 hours and 11 minutes after sunset on the evening the day begins", %w[lights-of-guidance]],
    ascension_bahaullah: ["About 8 hours after sunset (3 a.m.), by the sun", %w[lights-of-guidance uhj-2017-12-20]],
    martyrdom_bab: ["About noon", %w[dawn-breakers]],
    ascension_abdulbaha: ["About one hour after midnight, by the sun", %w[lights-of-guidance]]
  }.freeze

  def self.plain(html)
    html.gsub(%r{</?u>}, "").gsub(%r{<sup>(.*?)</sup>}, '\1').unicode_normalize(:nfc)
  end

  def self.confidence(year)
    CONFIDENCE.find { |range, _, _| range.cover?(year) }.then { |_, label, note| [label, note] }
  end

  def self.iso(date) = date.iso8601

  def self.month_name(number) = plain(BahaiDate::Month.new(number).html)

  def self.year(number)
    y = BahaiDate::Year.new(number)
    label, = confidence(number)
    first = BahaiDate::BahaiDate.new(year: number, month: 1, day: 1)
    ayyam = BahaiDate::OccasionFactory.ayyam_i_ha_range(number)
    fast = BahaiDate::OccasionFactory.fasting_range(number)

    months = (1..19).map do |m|
      {
        number: m,
        name: month_name(m),
        translation: BahaiDate::Month.new(m).translation,
        first_day: iso(BahaiDate::BahaiDate.new(year: number, month: m, day: 1).gregorian_date)
      }
    end

    holy_days = HOLY_DAYS.filter_map do |id|
      first_year = BahaiDate::OccasionFactory.first_year(id)
      next if number < first_year

      occasion = BahaiDate::OccasionFactory::OCCASIONS.fetch(id)
      month, day = BahaiDate::OccasionFactory.find(id, number).split(".").map(&:to_i)
      date = BahaiDate::BahaiDate.new(year: number, month: month, day: day)
      {
        id: id.to_s,
        name: plain(occasion[:short_title_html]),
        month: month,
        month_name: month_name(month),
        day: day,
        date: iso(date.gregorian_date),
        work_suspended: occasion[:work_suspended],
        status: status(id, number, first_year)
      }
    end.sort_by { |h| h[:date] }

    {
      year: number,
      year_name: plain(y.html),
      year_translation: y.translation,
      year_in_vahid: y.number,
      vahid: y.vahid,
      kull_i_shay: y.kull_i_shay,
      confidence: label,
      nawruz: iso(first.gregorian_date),
      days_in_year: (BahaiDate::Logic.leap?(number) ? 366 : 365),
      ayyam_i_ha: {first: iso(ayyam.first), last: iso(ayyam.last), days: (ayyam.last - ayyam.first).to_i + 1},
      fast: {first: iso(fast.first), last: iso(fast.last)},
      months: months,
      holy_days: holy_days
    }.merge((number < 172) ? {eastern_reconstruction: eastern(number)} : {})
  end

  def self.status(id, year, first_year)
    if id == :covenant
      (year < COVENANT_FIRST_KNOWN) ? "proleptic" : "observed"
    elsif year == first_year && BahaiDate::OccasionFactory::FIRST_YEARS.key?(id)
      "event-year"
    else
      "observed"
    end
  end

  # Naw-Rúz by the rule used from 172 B.E. (the equinox before sunset in
  # Ṭihrán), applied to an earlier year: a modern reconstruction, close to but
  # not the same as what almanacs in Iran gave at the time.
  def self.eastern_nawruz(gregorian_year)
    (gregorian_year >= 2015) ? BahaiDate::Logic.nawruz_for(gregorian_year) : BahaiDate::Logic.new.spring_equinox_in_tehran(gregorian_year)
  end

  def self.eastern(number)
    g = number + 1843
    nawruz = eastern_nawruz(g)
    logic = BahaiDate::Logic.new
    equinox = BahaiDate::Astro.utc(BahaiDate::Astro.date_of_vernal_equinox(g)).to_time
    gap = [nawruz, nawruz - 1].map { |d| ((equinox - logic.sunset_time_for(d)) / 60).abs }.min
    {
      nawruz: iso(nawruz),
      ayyam_i_ha_days: (eastern_nawruz(g + 1) - nawruz).to_i - 361,
      uncertain: gap < UNCERTAIN_MINUTES,
      minutes_from_sunset: gap.round(1)
    }
  end

  def self.years = (1..BahaiDate::Year::MAX).map { |n| year(n) }

  DATES_NOTE = "Each Gregorian date is the day on which the Bahá’í day ends. A Bahá’í day begins at sunset, so it begins on the evening before the date given."

  def self.meta
    {
      title: "Bahá’í (Badí‘) calendar dates, 1 to #{BahaiDate::Year::MAX} B.E. (21 March 1844 to March 3001)",
      generated_by: "bahai_date #{BahaiDate::VERSION} (https://github.com/lessan/bahai-date)",
      about: "#{SITE}/data/",
      rules: "#{SITE}/rules.html",
      dates: DATES_NOTE,
      confidence_levels: CONFIDENCE.map { |range, label, note| {years: "#{range.first}-#{range.last}", label: label, note: note} },
      holy_day_status: STATUSES,
      eastern_reconstruction: "For 1-171 B.E.: Naw-Rúz by the rule used from 172 B.E. (the day, sunset to sunset in Ṭihrán, in which the March equinox falls), applied backwards, and the length of Ayyám-i-Há that follows from it. A modern reconstruction, not a record of what any community observed; uncertain where the equinox falls within #{UNCERTAIN_MINUTES} minutes of sunset. Bahá’ís in Iran also kept the Twin Holy Days, the Declaration and the Martyrdom of the Báb on Islamic lunar dates, which are not given here."
    }
  end

  # The header of one year's file: only what applies to that year.
  def self.year_meta(y)
    _, note = confidence(y[:year])
    statuses = y[:holy_days].map { |h| h[:status] }.uniq
    header = {
      "$schema": "#{SITE}/data/schema/year.schema.json",
      about: "#{SITE}/data/",
      dates: DATES_NOTE,
      confidence_note: note
    }
    header[:holy_day_status] = STATUSES.slice(*statuses) unless statuses == ["observed"]
    header[:eastern_reconstruction_note] = meta[:eastern_reconstruction] if y[:eastern_reconstruction]
    header
  end

  def self.facts
    holy = HOLY_DAYS.map do |id|
      o = BahaiDate::OccasionFactory::OCCASIONS.fetch(id)
      from172 = BahaiDate::OccasionFactory::DATES.merge(BahaiDate::OccasionFactory::DATES_AFTER_172).find { |_, ids| ids.include?(id) }&.first
      before172 = BahaiDate::OccasionFactory::DATES.merge(BahaiDate::OccasionFactory::DATES_BEFORE_172).find { |_, ids| ids.include?(id) }&.first
      badi = ->(key) { key&.split(".")&.map(&:to_i)&.then { |m, d| {month: m, month_name: month_name(m), day: d} } }
      entry = {
        id: id.to_s,
        name: plain(o[:short_title_html]),
        work_suspended: o[:work_suspended],
        from_172: badi.call(from172) || {rule: (id == :birth_bab) ? "The first day after the eighth new moon after Naw-Rúz, in Ṭihrán" : "The second day after the eighth new moon after Naw-Rúz, in Ṭihrán"},
        before_172_western: badi.call(before172),
        first_year: BahaiDate::OccasionFactory.first_year(id)
      }
      if (hour, sources = COMMEMORATION[id])
        entry[:commemoration] = {time: hour, sources: sources}
      end
      entry
    end

    {
      title: "Facts about the Bahá’í (Badí‘) calendar",
      generated_by: meta[:generated_by],
      about: "#{SITE}/rules.html",
      sources: "#{SITE}/sources.html",
      day: "From sunset to sunset. Gregorian dates in this dataset are the day on which the Bahá’í day ends.",
      weekdays: BahaiDate::Weekday::TITLES_HTML.each_with_index.map { |n, i| {number: i + 1, name: plain(n), translation: BahaiDate::Weekday::TITLES_EN[i], gregorian: BahaiDate::Weekday::ENGLISH_EQUIVALENTS[i]} },
      day_of_rest: "Friday (Istiqlál)",
      months: (1..19).map { |m| {number: m, name: month_name(m), translation: BahaiDate::Month.new(m).translation} },
      ayyam_i_ha: "4 or 5 intercalary days between months 18 and 19, making the year end the day before the next Naw-Rúz",
      fast: "Month 19, ‘Alá’",
      years_of_a_vahid: (1..19).map { |n| {number: n, name: plain(BahaiDate::Year::TITLES_HTML[n - 1]), translation: BahaiDate::Year::TITLES_EN[n - 1]} },
      vahid: "A cycle of 19 years",
      kull_i_shay: "19 Váḥids, 361 years",
      epoch: "Year 1 B.E. began at Naw-Rúz 1844 (21 March by the Western convention). Year n begins in March of Gregorian year 1843 + n.",
      rules_from_172: {
        nawruz: "The Bahá’í day (sunset to sunset in Ṭihrán) in which the March equinox occurs.",
        twin_holy_days: "The first and second days after the day in which the eighth new moon (conjunction) after Naw-Rúz occurs, reckoned in Ṭihrán. A new moon during the day of Naw-Rúz is not counted.",
        ayyam_i_ha: "(next Naw-Rúz − this Naw-Rúz) − 361 days",
        source: "#{SITE}/sources.html#uhj-2014-07-10"
      },
      rules_before_172_western: {
        nawruz: "21 March",
        ayyam_i_ha: "26 February to 1 March (5 days if the following February has 29 days)",
        fast: "2 to 20 March",
        source: "#{SITE}/sources.html#bahai-world"
      },
      holy_days: holy,
      tehran: {latitude: BahaiDate::Logic::TEHRAN_LAT, longitude: BahaiDate::Logic::TEHRAN_LONG, utc_offset: BahaiDate::Logic::TEHRAN_UTC_OFFSET, sunset_zenith_degrees: BahaiDate::Sunset::OFFICIAL_ZENITH},
      supported_years: {first: 1, last: BahaiDate::Year::MAX, gregorian: "21 March 1844 to March #{BahaiDate::Logic::MAX_GREGORIAN_YEAR}"},
      confidence_levels: meta[:confidence_levels]
    }
  end

  # Hard cases with their answers, for checking an implementation.
  def self.test_vectors
    l = BahaiDate::Logic
    conf = ->(year) { confidence(year).first }
    convert = lambda do |date, note|
      b = BahaiDate::BahaiDate.new(date: Date.iso8601(date))
      month = (b.month.number == -1) ? "Ayyám-i-Há" : month_name(b.month.number)
      {gregorian: date, year: b.year.bahai_era, month: b.month.number, month_name: month, day: b.day.number,
       weekday: plain(b.weekday.html), confidence: conf.call(b.year.bahai_era), note: note}
    end
    nawruz = ->(g, note) { {gregorian_year: g, year: g - 1843, nawruz: iso(l.nawruz_for(g)), confidence: conf.call(g - 1843), note: note} }
    twins = lambda do |be, note|
      t = l.twin_holy_days_date(be)
      {year: be, birth_of_the_bab: iso(t), birth_of_bahaullah: iso(t + 1), confidence: conf.call(be), note: note}
    end
    ayyam = lambda do |be, note|
      r = BahaiDate::OccasionFactory.ayyam_i_ha_range(be)
      {year: be, first: iso(r.first), last: iso(r.last), days: (r.last - r.first).to_i + 1, confidence: conf.call(be), note: note}
    end

    {
      title: "Test cases for Bahá’í date calculations",
      generated_by: meta[:generated_by],
      about: "#{SITE}/rules.html#edge-cases",
      dates: DATES_NOTE,
      gregorian_to_badi: [
        convert.call("1844-03-21", "The first day of the calendar (Western convention)."),
        convert.call("2015-03-20", "The last day of 171 B.E., before the 2014 rules took effect."),
        convert.call("2015-03-21", "Naw-Rúz 172 B.E., the first year of the 2014 rules."),
        convert.call("2016-02-29", "29 February inside a four-day Ayyám-i-Há."),
        convert.call("2018-03-01", "The fifth day of Ayyám-i-Há in a year whose February had 28 days."),
        convert.call("2026-11-28", "A Holy Day (Ascension of ‘Abdu’l-Bahá)."),
        convert.call("2027-02-15", "January to March belongs to the Bahá’í year that began the previous March."),
        convert.call("2059-03-20", "Naw-Rúz on 20 March: the equinox about a minute and a half before sunset.")
      ],
      nawruz: [
        nawruz.call(2016, "The first Naw-Rúz on 20 March under the 2014 rules."),
        nawruz.call(2026, "The equinox about 11 seconds after sunset in Ṭihrán by this gem’s calculation; the official date agrees."),
        nawruz.call(2059, "The equinox about 98 seconds before sunset."),
        nawruz.call(2352, "The first year after badiDate’s range; the equinox within 8 minutes of sunset."),
        nawruz.call(2418, "The equinox about 15 seconds before the exact sunset; this gem truncates sunset to the minute, which makes it 21 March. Treat as uncertain.")
      ],
      twin_holy_days: [
        twins.call(172, "The first year of the new-moon rule: the eighth new moon after sunset on 11 November 2015 (9 Qudrat)."),
        twins.call(184, "The eighth new moon within 6 minutes of sunset in Ṭihrán."),
        twins.call(191, "A new moon falls during the day of Naw-Rúz (20 March 2034) and is not counted; counting it would give 13 and 14 October."),
        twins.call(210, "A new moon during the day of Naw-Rúz, not counted (2053)."),
        twins.call(181, "The two days fall in different months (19 ‘Ilm and 1 Qudrat)."),
        twins.call(218, "The earliest month: 19 Mashíyyat and 1 ‘Ilm (2061).")
      ],
      ayyam_i_ha: [
        ayyam.call(174, "Five days though February 2018 had 28."),
        ayyam.call(176, "Four days though February 2020 had 29."),
        ayyam.call(171, "Western convention: four days, as February 2015 had 28.")
      ]
    }
  end

  # Every generated file, as {relative path => content}.
  def self.files(all = years)
    files = {}
    files["years.json"] = JSON.generate({meta: meta, years: all}) + "\n"
    all.each { |y| files["years/#{y[:year]}.json"] = JSON.pretty_generate(year_meta(y).merge(y)) + "\n" }
    files["facts.json"] = JSON.pretty_generate(facts) + "\n"
    files["test-vectors.json"] = JSON.pretty_generate(test_vectors) + "\n"

    files["years.csv"] = CSV.generate do |csv|
      csv << %w[year year_name vahid kull_i_shay confidence nawruz days_in_year ayyam_i_ha_first ayyam_i_ha_last ayyam_i_ha_days fast_first fast_last birth_of_the_bab birth_of_bahaullah eastern_nawruz eastern_ayyam_i_ha_days eastern_uncertain]
      all.each do |y|
        twins = y[:holy_days].to_h { |h| [h[:id], h[:date]] }
        east = y[:eastern_reconstruction] || {}
        csv << [y[:year], y[:year_name], y[:vahid], y[:kull_i_shay], y[:confidence], y[:nawruz], y[:days_in_year],
          y[:ayyam_i_ha][:first], y[:ayyam_i_ha][:last], y[:ayyam_i_ha][:days], y[:fast][:first], y[:fast][:last],
          twins["birth_bab"], twins["birth_bahaullah"], east[:nawruz], east[:ayyam_i_ha_days], east[:uncertain]]
      end
    end

    files["holy-days.csv"] = CSV.generate do |csv|
      csv << %w[year id name month month_name day date work_suspended status confidence]
      all.each { |y| y[:holy_days].each { |h| csv << [y[:year], h[:id], h[:name], h[:month], h[:month_name], h[:day], h[:date], h[:work_suspended], h[:status], y[:confidence]] } }
    end

    files["months.csv"] = CSV.generate do |csv|
      csv << %w[year month name translation first_day confidence]
      all.each { |y| y[:months].each { |m| csv << [y[:year], m[:number], m[:name], m[:translation], m[:first_day], y[:confidence]] } }
    end

    files
  end

  # Files in OUT that are written by hand, not generated.
  HAND_WRITTEN = %w[README.md events.json schema/year.schema.json].freeze

  def self.write
    generated = files
    FileUtils.rm_rf(File.join(OUT, "years"))
    (Dir.glob("*.{json,csv}", base: OUT) - HAND_WRITTEN).each { |f| File.delete(File.join(OUT, f)) }
    generated.each do |path, content|
      full = File.join(OUT, path)
      FileUtils.mkdir_p(File.dirname(full))
      File.write(full, content)
    end
  end
end

DataExport.write if $PROGRAM_NAME == __FILE__
