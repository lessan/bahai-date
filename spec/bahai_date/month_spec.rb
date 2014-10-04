require 'bahai_date/month'

module BahaiDate

  describe Month do
    it "can be created given a number from 1 to 19 or -1" do
      expect(Month.new(1)).to_not be_nil
      expect(Month.new(19)).to_not be_nil
      expect(Month.new(-1)).to_not be_nil
    end

    it "can't be created with a number other than 1 to 19 or -1" do
      expect { Month.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid month. Please use 1 to 19 or -1 for Ayyam-i-Ha.")

      expect { Month.new(-2) }.to raise_error(
        ArgumentError, "'-2' is not a valid month. Please use 1 to 19 or -1 for Ayyam-i-Ha.")

      expect { Month.new(20) }.to raise_error(
        ArgumentError, "'20' is not a valid month. Please use 1 to 19 or -1 for Ayyam-i-Ha.")

      expect { Month.new('hello') }.to raise_error(
        ArgumentError, "'0' is not a valid month. Please use 1 to 19 or -1 for Ayyam-i-Ha.")
    end

    context "when created using -1" do

      it "has a title of Ayyam-i-Ha" do
        month = Month.new(-1)

        expect(month.to_s).to eq "Ayyam-i-Ha"
      end
    end

    subject(:month) { Month.new(1) }

    it "can be converted to string" do
      expect(month.to_s).to eq "Baha"
    end

    it "provides access to the month number" do
      expect(month.number).to be 1
    end

    it "provides access to the translated title" do
      expect(month.translation).to eq "Splendour"
    end

    it "provides access to the title in HTML" do
      expect(month.html).to eq "Bahá"
    end
  end

end
