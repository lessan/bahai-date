require "json"

module BahaiDate
  # Checks this gem against Table A of "Bahá’í Dates 172 to 221 B.E.", the
  # table the Bahá’í World Centre sent to National Spiritual Assemblies on
  # 11 December 2014: the primary source for these years.
  describe "Table A of the official Bahá’í Dates 172 to 221 B.E." do
    data = JSON.parse(File.read(File.expand_path("../fixtures/uhj_table_a.json", __dir__)))
    years = data["years"]

    # The table's month names, as the gem's HTML titles without markup.
    def self.badi(date)
      "#{date.day.number} #{date.month.html.gsub(%r{</?u>}, "")}"
    end

    it "has the fifty years 172 to 221" do
      expect(years.map { |row| row["year"] }).to eq (172..221).to_a
    end

    years.each do |row|
      year = row["year"]

      it "matches the table for #{year} B.E." do
        birth_bab = BahaiDate.new(date: Logic.twin_holy_days_date(year))
        birth_bahaullah = birth_bab + 1
        ayyam_i_ha = OccasionFactory.ayyam_i_ha_range(year)
        twin_badi = if birth_bab.month.number == birth_bahaullah.month.number
          "#{birth_bab.day.number}, #{self.class.badi(birth_bahaullah)}"
        else
          "#{self.class.badi(birth_bab)}, #{self.class.badi(birth_bahaullah)}"
        end

        aggregate_failures do
          expect(BahaiDate.new(year: year, month: 1, day: 1).gregorian_date.iso8601).to eq row["nawruz"]
          expect(birth_bab.gregorian_date.iso8601).to eq row["birth_of_the_bab"]
          expect(birth_bahaullah.gregorian_date.iso8601).to eq row["birth_of_bahaullah"]
          expect(twin_badi.unicode_normalize(:nfc)).to eq row["twin_holy_days_badi"].unicode_normalize(:nfc)
          expect(ayyam_i_ha.first.iso8601).to eq row["ayyam_i_ha"]["first"]
          expect(ayyam_i_ha.last.iso8601).to eq row["ayyam_i_ha"]["last"]
        end
      end
    end
  end
end
