require 'bahai_date/weekday'

module BahaiDate

  describe Weekday do
    it "can be created given a number from 1 to 7" do
      expect(Weekday.new(1)).to_not be_nil
      expect(Weekday.new(7)).to_not be_nil
    end

    it "can't be created with a number other than 1 to 7" do
      expect { Weekday.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid weekday. Please use 1 to 7.")

      expect { Weekday.new(8) }.to raise_error(
        ArgumentError, "'8' is not a valid weekday. Please use 1 to 7.")

      expect { Weekday.new('hello') }.to raise_error(
        ArgumentError, "'0' is not a valid weekday. Please use 1 to 7.")
    end

    it "provides access to various attributes" do
      weekday = Weekday.new(1)

      expect(weekday.number).to eq(1)
      expect(weekday.title).to eq("Jalal")
      expect(weekday.title_en).to eq("Glory")
      expect(weekday.english_equivalent).to eq("Saturday")
    end
  end

end
