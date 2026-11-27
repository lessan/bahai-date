require "json"

module BahaiDate
  # Checks this gem against badiDate (https://github.com/janrg/badiDate), an
  # independent JavaScript implementation that takes its equinoxes from the JPL
  # DE405 ephemeris to 2200 and VSOP87 after, for every year it supports:
  # 172-507 B.E. (2015-2351), well past the fifty years bahai.org publishes.
  describe "the badiDate library's dates" do
    data = JSON.parse(File.read(File.expand_path("../fixtures/badidate_dates.json", __dir__)))
    years = data["years"]

    it "covers 172 to 507 B.E." do
      expect(years.map { |row| row["year"] }).to eq (172..507).to_a
    end

    it "agrees on Naw-Ruz, the Twin Holy Days and Ayyam-i-Ha for every year" do
      wrong = years.filter_map do |row|
        year = row["year"]
        ours = {
          "nawruz" => BahaiDate.new(year: year, month: 1, day: 1).gregorian_date.iso8601,
          "birthBab" => Logic.twin_holy_days_date(year).iso8601,
          "birthBahaullah" => (Logic.twin_holy_days_date(year) + 1).iso8601,
          "ayyamiHa" => Logic.leap?(year) ? 5 : 4
        }
        theirs = row.slice(*ours.keys)
        [year, theirs, ours] unless theirs == ours
      end

      expect(wrong).to be_empty, "years that differ: #{wrong.first(5).inspect}"
    end
  end
end
