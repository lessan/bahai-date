module BahaiDate
  describe Year do
    it "can be created given a number greater than or equal to 1" do
      expect(Year.new(1)).to_not be_nil
      expect(Year.new(160)).to_not be_nil
    end

    it "can't be created with a number less than 1" do
      expect { Year.new(0) }.to raise_error(
        ArgumentError, "'0' is not a valid year. Please use a number from 1 to 1157."
      )

      expect { Year.new("hello") }.to raise_error(
        ArgumentError, "'hello' is not a valid year. Please use a number from 1 to 1157."
      )
    end

    it "can be created up to 1157, the last year that begins by the Gregorian year 3000" do
      expect(Year.new(1157).bahai_era).to eq 1157
      expect { Year.new(1158) }.to raise_error(ArgumentError, "'1158' is not a valid year. Please use a number from 1 to 1157.")
      expect { Year.new(10**20) }.to raise_error(ArgumentError)
    end

    it "translates the name of every year of a Vahid" do
      expect(Year::TITLES_EN.size).to eq 19
      expect(Year::TITLES.size).to eq 19
      expect(Year::TITLES_HTML.size).to eq 19
      expect(Year.new(17).translation).to eq "Luminous"
      expect(Year.new(18).translation).to eq "Most Luminous"
      expect(Year.new(19).translation).to eq "Unity"
    end

    subject(:year) { Year.new(1) }

    it "can be converted to string showing the B.E. number" do
      expect(year.to_s).to eq "1"
    end

    it "provides access to the title" do
      expect(year.title).to eq "Alif"
    end

    it "provides access to the year number" do
      expect(year.number).to be 1
    end

    it "provides access to the translated title" do
      expect(year.translation).to eq "A"
    end

    it "provides access to the title in HTML" do
      expect(year.html).to eq "Alif"
    end

    it "provides access to the vahid" do
      expect(year.vahid).to be 1
    end

    it "provides access to the kull-i-shay" do
      expect(year.kull_i_shay).to be 1
    end

    it "calculates the number properly" do
      year = Year.new(1)
      expect(year.number).to eq(1)

      year = Year.new(19)
      expect(year.number).to eq(19)

      year = Year.new(20)
      expect(year.number).to eq(1)

      year = Year.new(361)
      expect(year.number).to eq(19)

      year = Year.new(362)
      expect(year.number).to eq(1)
    end

    it "calculates the vahid properly" do
      year = Year.new(1)
      expect(year.vahid).to eq(1)

      year = Year.new(20)
      expect(year.vahid).to eq(2)

      year = Year.new(361)
      expect(year.vahid).to eq(19)

      year = Year.new(362)
      expect(year.vahid).to eq(1)
    end

    it "calculates the kull-i-shay properly" do
      year = Year.new(1)
      expect(year.kull_i_shay).to eq(1)

      year = Year.new(361)
      expect(year.kull_i_shay).to eq(1)

      year = Year.new(362)
      expect(year.kull_i_shay).to eq(2)
    end

    context "working with a hash of months" do
      it "is readable" do
        year = Year.new(1)
        expect(year.months).to eq({})
      end

      it "can be added to" do
        year = Year.new(1)
        year.add_month(-1)
        expect(year.months[-1].number).to be(-1)
      end

      it "doesn't create a new Month object if one exists" do
        year = Year.new(1)
        month = year.add_month(1)
        year.add_month(1)
        expect(year.months[1]).to be month
      end
    end
  end
end
