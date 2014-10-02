require 'bahai_date/month'

module BahaiDate

  describe Month do
    it "can be created given a number from 1 to 19" do
      expect(Month.new(1)).to_not be_nil
      expect(Month.new(19)).to_not be_nil
    end

    it "can't be created with a number other than 1 to 19" do
      expect { Month.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid month. Please use 1 to 19.")

      expect { Month.new(20) }.to raise_error(
        ArgumentError, "'20' is not a valid month. Please use 1 to 19.")

      expect { Month.new('hello') }.to raise_error(
        ArgumentError, "'0' is not a valid month. Please use 1 to 19.")
    end

    it "provides access to various attributes" do
      month = Month.new(1)

      expect(month.number).to eq(1)
      expect(month.title).to eq("Baha")
      expect(month.title_en).to eq("Splendour")
    end
  end

end
