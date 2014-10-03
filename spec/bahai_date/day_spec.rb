require 'bahai_date/day'

module BahaiDate

  describe Day do
    it "can be created given a number from 1 to 19" do
      expect(Day.new(1)).to_not be_nil
      expect(Day.new(19)).to_not be_nil
    end

    it "can't be created with a number other than 1 to 19" do
      expect { Day.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid day. Please use 1 to 19.")

      expect { Day.new(20) }.to raise_error(
        ArgumentError, "'20' is not a valid day. Please use 1 to 19.")

      expect { Day.new('hello') }.to raise_error(
        ArgumentError, "'0' is not a valid day. Please use 1 to 19.")
    end

    subject(:day) { Day.new(1) }

    it "can be converted to string" do
      expect(day.to_s).to eq "Baha"
    end

    it "provides access to the day number" do
      expect(day.number).to be 1
    end

    it "provides access to the translated title" do
      expect(day.translation).to eq "Splendour"
    end

    it "provides access to the title in HTML" do
      expect(day.html).to eq "Bahá"
    end
  end

end
