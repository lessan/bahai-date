require "json"

module BahaiDate
  # The calendar as bahai.org renders it, ready to compare against.
  module PublishedCalendar
    FIXTURE = File.expand_path("../fixtures/bahai_org_calendar.json", __dir__)
    DATA = JSON.parse(File.read(FIXTURE))
    ERAS = DATA["eras"]

    # The page's titles against the gem's occasion short titles.
    OCCASIONS = {
      "Naw-Rúz" => "Naw-Ruz",
      "First Day of Riḍván" => "1st day of Ridvan",
      "Ninth Day of Riḍván" => "9th day of Ridvan",
      "Twelfth Day of Riḍván" => "12th day of Ridvan",
      "Declaration of the Báb" => "Declaration of the Bab",
      "Ascension of Bahá’u’lláh" => "Ascension of Baha'u'llah",
      "Martyrdom of the Báb" => "Martyrdom of the Bab",
      "Birth of the Báb" => "Birth of the Bab",
      "Birth of Bahá’u’lláh" => "Birth of Baha'u'llah",
      "Day of the Covenant" => "Day of the Covenant",
      "Ascension of ‘Abdu’l-Bahá" => "Ascension of Abdu'l-Baha"
    }.freeze

    FAST = "Bahá’í Fast"

    TWINS = ["Birth of the Báb", "Birth of Bahá’u’lláh"].freeze

    def self.date(str)
      Date.iso8601(str)
    end

    # The two days whose date depends on the new moon, not on the month layout.
    def self.twin_dates(era)
      TWINS.map { |title| date(era["dates"].find { |observance| observance["title"] == title }["startDate"]) }
    end

    # Every day of an era as [date, month number, day number], derived only from
    # what the page publishes: the 19 month starts and the Ayyám-i-Há range.
    def self.days(era)
      starts = era["months"].map { |month| [date(month["startDate"]), month["number"]] }
      ayyam_start = date(era["ayyamIHa"]["startDate"])
      ayyam_end = date(era["ayyamIHa"]["endDate"])
      first = starts.first.first
      last = starts.last.first + 18

      (first..last).map do |day|
        if day.between?(ayyam_start, ayyam_end)
          [day, -1, (day - ayyam_start).to_i + 1]
        else
          index = starts.rindex { |month_start, _| month_start <= day }
          start, number = starts[index]
          [day, number, (day - start).to_i + 1]
        end
      end
    end
  end

  # Checks this gem against what bahai.org actually publishes.
  #
  # The fixture is the rendered page, collected by
  # script/collect_published_calendar.js: for every year its year-selector
  # offers, the start date of all 19 months, the Ayyám-i-Há range, and the holy
  # days and significant dates. Re-run that script to refresh it.
  describe "the published bahai.org calendar" do
    it "is the page's calendar for eras 172 to 221" do
      expect(PublishedCalendar::ERAS.map { |era| era["bahaiEra"] }).to eq (172..221).to_a
      expect(PublishedCalendar::DATA["source"]["url"]).to eq "https://www.bahai.org/action/devotional-life/calendar"
    end

    it "lists 19 months and 12 dated observances for every era" do
      expect(PublishedCalendar::ERAS.map { |era| era["months"].size }.uniq).to eq [19]
      expect(PublishedCalendar::ERAS.map { |era| era["dates"].size }.uniq).to eq [12]
      expect(PublishedCalendar::ERAS.flat_map { |era| era["dates"].map { |d| d["title"] } }.uniq.sort).to eq(
        (PublishedCalendar::OCCASIONS.keys + [PublishedCalendar::FAST]).sort
      )
    end

    it "runs the eras together, so month 19 is 19 days long throughout" do
      gaps = PublishedCalendar::ERAS.each_cons(2).filter_map do |era, following|
        month_19 = PublishedCalendar.date(era["months"].last["startDate"])
        next_nawruz = PublishedCalendar.date(following["months"].first["startDate"])
        [era["bahaiEra"], (next_nawruz - month_19).to_i] unless (next_nawruz - month_19).to_i == 19
      end

      expect(gaps).to be_empty, "eras whose 'Ala is not 19 days: #{gaps.inspect}"
    end

    PublishedCalendar::ERAS.each do |era|
      era_number = era["bahaiEra"]

      context "era #{era_number}" do
        it "matches the published month starts, names and Ayyam-i-Ha" do
          aggregate_failures do
            era["months"].each do |month|
              start = PublishedCalendar.date(month["startDate"])
              bahai_date = BahaiDate.new(year: era_number, month: month["number"], day: 1)

              expect(bahai_date.gregorian_date).to eq start
              expect(BahaiDate.new(date: start).to_s).to eq "#{era_number}.#{month["number"]}.1"
              expect(bahai_date.month.html.gsub(/<\/?u>/, "").unicode_normalize(:nfc)).to eq month["name"].unicode_normalize(:nfc)
            end

            ayyam_start = PublishedCalendar.date(era["ayyamIHa"]["startDate"])
            ayyam_end = PublishedCalendar.date(era["ayyamIHa"]["endDate"])
            intercalary = (ayyam_end - ayyam_start).to_i + 1

            expect(Logic.leap?(era_number)).to eq(intercalary == 5)
            expect(BahaiDate.new(date: ayyam_start).to_s).to eq "#{era_number}.-1.1"
            expect(BahaiDate.new(date: ayyam_end).to_s).to eq "#{era_number}.-1.#{intercalary}"

            twins = PublishedCalendar.twin_dates(era)
            expect(Logic.twin_holy_days_date(era_number)).to eq twins.first
            expect(Logic.twin_holy_days_date(era_number) + 1).to eq twins.last
          end
        end

        it "converts every day of the era" do
          wrong = PublishedCalendar.days(era).filter_map do |date, month, day|
            actual = BahaiDate.new(date: date).to_s
            expected = "#{era_number}.#{month}.#{day}"
            [date.iso8601, expected, actual] unless actual == expected
          end

          expect(wrong).to be_empty, "wrong dates: #{wrong.first(5).inspect}"
        end

        it "converts the start of every month back to the published date" do
          wrong = era["months"].filter_map do |month|
            expected = PublishedCalendar.date(month["startDate"])
            actual = BahaiDate.new(year: era_number, month: month["number"], day: 1).gregorian_date
            ["#{era_number}.#{month["number"]}.1", expected.iso8601, actual.iso8601] unless actual == expected
          end

          expect(wrong).to be_empty, "wrong month starts: #{wrong.first(5).inspect}"
        end
      end
    end

    it "labels every published holy day and significant date" do
      wrong = PublishedCalendar::ERAS.flat_map do |era|
        era_number = era["bahaiEra"]

        era["dates"].filter_map do |observance|
          title = observance["title"]
          start = PublishedCalendar.date(observance["startDate"])
          finish = PublishedCalendar.date(observance["endDate"])

          if title == PublishedCalendar::FAST
            [era_number, title, start.iso8601, finish.iso8601] unless OccasionFactory.fasting_range(era_number) == (start..finish)
          else
            titles = BahaiDate.new(date: start).occasions.map(&:short_title)
            expected = PublishedCalendar::OCCASIONS.fetch(title)
            [era_number, title, start.iso8601, titles] unless titles.include?(expected)
          end
        end
      end

      expect(wrong).to be_empty, "missing observances: #{wrong.first(5).inspect}"
    end
  end
end
