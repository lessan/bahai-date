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

    it "provides access to various attributes" do
      day = Day.new(1)

      expect(day.number).to eq(1)
      expect(day.title).to eq("Baha")
      expect(day.title_en).to eq("Splendour")
    end
  end

end
