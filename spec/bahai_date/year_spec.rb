require 'bahai_date/year'

module BahaiDate

  describe Year do
    it "can be created given a number greater than or equal to 1" do
      expect(Year.new(1)).to_not be_nil
      expect(Year.new(160)).to_not be_nil
    end

    it "can't be created with a number less than 1" do
      expect { Year.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid year. Please use a number greater than or equal to 1.")

      expect { Year.new('hello') }.to raise_error(
        ArgumentError, "'0' is not a valid year. Please use a number greater than or equal to 1.")
    end

    it "provides access to various attributes" do
      year = Year.new(1)

      expect(year.bahai_era).to eq(1)
      expect(year.number).to eq(1)
      expect(year.title).to eq("Alif")
      expect(year.title_en).to eq("A")
      expect(year.vahid).to eq(1)
      expect(year.kull_i_shay).to eq(1)
    end

    it "calculates the number, vahid, and kull-i-shay properly" do
      year = Year.new(1)
      expect(year.number).to eq(1)
      expect(year.vahid).to eq(1)
      expect(year.kull_i_shay).to eq(1)

      year = Year.new(19)
      expect(year.number).to eq(19)
      expect(year.vahid).to eq(1)
      expect(year.kull_i_shay).to eq(1)

      year = Year.new(20)
      expect(year.number).to eq(1)
      expect(year.vahid).to eq(2)
      expect(year.kull_i_shay).to eq(1)

      year = Year.new(361)
      expect(year.number).to eq(19)
      expect(year.vahid).to eq(19)
      expect(year.kull_i_shay).to eq(1)

      year = Year.new(362)
      expect(year.number).to eq(1)
      expect(year.vahid).to eq(1)
      expect(year.kull_i_shay).to eq(2)
    end
  end

end
