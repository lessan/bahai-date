#!/usr/bin/env ruby
# Writes the dates dataset in docs/data/ from this gem:
#
#   bundle exec ruby script/generate_data.rb
#
# spec/data_spec.rb fails if the files no longer match what the gem computes,
# so re-run this after any change to the calculations.

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bahai_date"
require "csv"
require "fileutils"
require "json"

module DataExport
  OUT = File.expand_path("../docs/data", __dir__)

  # How far each range of years can be trusted. See docs/calendar-rules.md.
  CONFIDENCE = [
    [1..66, "convention-proleptic", "The Western convention set out under Shoghi Effendi (Naw-Rúz on 21 March, the Twin Holy Days on 20 October and 12 November), applied to years before any Western Bahá’í community kept the calendar (its first attested use in the West is 1910). Bahá’ís in Iran reckoned differently; see eastern_reconstruction and docs/history.md."],
    [67..171, "convention", "The Western convention set out under Shoghi Effendi (Naw-Rúz on 21 March, the Twin Holy Days on 20 October and 12 November), as kept in the West. Bahá’ís in Iran reckoned differently; see eastern_reconstruction and docs/history.md."],
    [172..221, "published", "Matches the dates published by the Bahá’í World Centre for 172 to 221 B.E."],
    [222..507, "cross-checked", "Computed; agrees with the independent badiDate library (JPL ephemeris) for every year to 2351."],
    [508..BahaiDate::Year::MAX, "estimate", "Computed; the uncertainty in the Earth's rotation (Delta T) means some years may be a day out where the equinox falls close to sunset in Tehran."]
  ].freeze

  STATUSES = {
    "observed" => "An anniversary or festival kept in this year.",
    "event" => "The year of the event itself: the date is the day of the event, not an anniversary.",
    "proleptic" => "After the event but before the first known observance: the Day of the Covenant before 1901."
  }.freeze

  # The Day of the Covenant was appointed by ‘Abdu’l-Bahá after 1892; its first
  # known observance, in the West, is 1901 (58 B.E.).
  COVENANT_FIRST_KNOWN = 58

  # The equinox within this many minutes of sunset in Tehran makes a
  # reconstructed Naw-Rúz uncertain.
  UNCERTAIN_MINUTES = 15

  HOLY_DAYS = %i[nawruz ridvan_1 ridvan_9 ridvan_12 declaration_bab ascension_bahaullah martyrdom_bab
    birth_bab birth_bahaullah covenant ascension_abdulbaha].freeze

  def self.plain(html)
    html.gsub(%r{</?u>}, "").gsub(%r{<sup>(.*?)</sup>}, '\1')
  end

  def self.confidence(year)
    CONFIDENCE.find { |range, _, _| range.cover?(year) }.then { |_, label, note| [label, note] }
  end

  def self.iso(date) = date.iso8601

  def self.year(number)
    y = BahaiDate::Year.new(number)
    label, = confidence(number)
    first = BahaiDate::BahaiDate.new(year: number, month: 1, day: 1)
    ayyam = BahaiDate::OccasionFactory.ayyam_i_ha_range(number)
    fast = BahaiDate::OccasionFactory.fasting_range(number)

    months = (1..19).map do |m|
      month = BahaiDate::Month.new(m)
      {
        number: m,
        name: plain(month.html),
        translation: month.translation,
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
      "event"
    else
      "observed"
    end
  end

  # Naw-Rúz by the rule used from 172 B.E. (the equinox before sunset in
  # Tehran), applied to an earlier year: a modern reconstruction, close to but
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

  def self.meta
    {
      title: "Bahá’í (Badí‘) calendar dates, 1 to #{BahaiDate::Year::MAX} B.E.",
      generated_by: "bahai_date #{BahaiDate::VERSION} (https://github.com/lessan/bahai-date)",
      dates: "Each Gregorian date is the day on which the Bahá’í day ends. A Bahá’í day begins at sunset, so it begins on the evening before the date given.",
      rules: "https://github.com/lessan/bahai-date/blob/master/docs/calendar-rules.md",
      confidence: CONFIDENCE.map { |range, label, note| {years: "#{range.first}-#{range.last}", label: label, note: note} },
      holy_day_status: STATUSES,
      eastern_reconstruction: "For 1-171 B.E.: Naw-Rúz by the rule used from 172 B.E. (the day, sunset to sunset in Tehran, in which the March equinox falls), applied backwards, and the length of Ayyám-i-Há that follows from it. A modern reconstruction, not a record of what any community observed; uncertain where the equinox falls within #{UNCERTAIN_MINUTES} minutes of sunset. Bahá’ís in Iran also kept the Twin Holy Days, the Declaration and the Martyrdom of the Báb on Islamic lunar dates, which are not given here."
    }
  end

  # Every file, as {relative path => content}.
  def self.files(all = years)
    files = {}
    files["years.json"] = JSON.generate(meta.merge(years: all)) + "\n"
    all.each { |y| files["years/#{y[:year]}.json"] = JSON.pretty_generate(meta.except(:confidence).merge(y)) + "\n" }

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
      csv << %w[year id name month day date work_suspended status confidence]
      all.each { |y| y[:holy_days].each { |h| csv << [y[:year], h[:id], h[:name], h[:month], h[:day], h[:date], h[:work_suspended], h[:status], y[:confidence]] } }
    end

    files["months.csv"] = CSV.generate do |csv|
      csv << %w[year month name translation first_day confidence]
      all.each { |y| y[:months].each { |m| csv << [y[:year], m[:number], m[:name], m[:translation], m[:first_day], y[:confidence]] } }
    end

    files
  end

  # Files in OUT that are written by hand, not generated.
  HAND_WRITTEN = %w[README.md].freeze

  def self.write
    FileUtils.rm_rf(File.join(OUT, "years"))
    Dir.glob(File.join(OUT, "*.{json,csv}")).each { |f| File.delete(f) }
    files.each do |path, content|
      full = File.join(OUT, path)
      FileUtils.mkdir_p(File.dirname(full))
      File.write(full, content)
    end
  end
end

DataExport.write if $PROGRAM_NAME == __FILE__
