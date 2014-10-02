require 'bahai_date/bahai_date'

module BahaiDate

  describe BahaiDate do

    it "can be created" do
      bahai_date = BahaiDate.new

      expect(bahai_date).to_not be_nil
    end

    it "can be created from a Year, Month and Day" do
      bahai_date = BahaiDate.fromYMD(160, 19, 1)

      expect(bahai_date).to_not be_nil
    end

    it "can be created from a gregorian Date objects" do
      bahai_date = BahaiDate.fromDate(Date.new(2010, 1, 1))

      expect(bahai_date).to_not be_nil
    end

  end

end
