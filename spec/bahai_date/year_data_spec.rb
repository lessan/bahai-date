require 'bahai_date/year_data'

module BahaiDate

  describe YearData do

    it "supplies a Date object for Naw Ruz of a given year" do
      expect(YearData.nawruz_for(1844)).to eq(Date.new(1844,3,21))
    end

    it "determines whether a year is leap or not" do
      expect(YearData.is_leap?(1)).to eq(false)
      expect(YearData.is_leap?(4)).to eq(true)
      expect(YearData.is_leap?(168)).to eq(true)
    end

  end

end
