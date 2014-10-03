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

    subject(:weekday) { Weekday.new(1) }

    it "can be converted to string" do
      expect(weekday.to_s).to eq "Jalal"
    end

    it "provides access to the day number" do
      expect(weekday.number).to be 1
    end

    it "provides access to the translated title" do
      expect(weekday.translation).to eq "Glory"
    end

    it "provides access to the title in HTML" do
      expect(weekday.html).to eq "Jalál"
    end

    it "provides access to the English equivalent" do
      expect(weekday.english_equivalent).to eq("Saturday")
    end

  end

end
