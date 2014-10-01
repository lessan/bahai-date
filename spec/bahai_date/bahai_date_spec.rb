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


  describe WeekDay do
    it "can be created given a number from 1 to 7" do
      expect(WeekDay.new(1)).to_not be_nil
      expect(WeekDay.new(7)).to_not be_nil
    end

    it "can't be created with a number other than 1 to 7" do
      expect { WeekDay.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid week day. Please use 1 to 7.")

      expect { WeekDay.new(8) }.to raise_error(
        ArgumentError, "'8' is not a valid week day. Please use 1 to 7.")

      expect { WeekDay.new('hello') }.to raise_error(
        ArgumentError, "'0' is not a valid week day. Please use 1 to 7.")
    end

    it "provides access to various attributes" do
      weekday = WeekDay.new(1)

      expect(weekday.number).to eq(1)
      expect(weekday.title).to eq("Jalal")
      expect(weekday.title_en).to eq("Glory")
      expect(weekday.english_equivalent).to eq("Saturday")
    end
  end

end
