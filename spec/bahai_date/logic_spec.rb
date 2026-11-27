module BahaiDate
  describe Logic do
    it "supplies a Date object for Naw Ruz of a given year" do
      expect(Logic.nawruz_for(1844)).to eq(Date.new(1844, 3, 21))
    end

    it "determines whether a year is leap or not" do
      expect(Logic.leap?(1)).to eq(false)
      expect(Logic.leap?(4)).to eq(true)
      expect(Logic.leap?(168)).to eq(true)
      expect(Logic.leap?(171)).to eq(false)
      expect(Logic.leap?(172)).to eq(false)
      expect(Logic.leap?(173)).to eq(false)
      expect(Logic.leap?(174)).to eq(true)
      expect(Logic.leap?(175)).to eq(false)
      expect(Logic.leap?(176)).to eq(false)
      expect(Logic.leap?(177)).to eq(false)
    end

    it "supports Gregorian years up to 3001, where the year 1157 B.E. ends" do
      expect(Logic.nawruz_for(3001)).to be_a(Date)
      expect { Logic.nawruz_for(3002) }.to raise_error(ArgumentError, /outside the supported range/)
      expect { Logic.nawruz_for(10**12) }.to raise_error(ArgumentError, /outside the supported range/)
    end

    it "rejects Baha'i years after 1157 instead of computing nonsense" do
      expect { Logic.leap?(1158) }.to raise_error(ArgumentError, /not a valid year/)
      expect { Logic.twin_holy_days_date(10**6) }.to raise_error(ArgumentError, /not a valid year/)
      expect { OccasionFactory.find(:birth_bab, 10**6) }.to raise_error(ArgumentError, /not a valid year/)
    end

    it "computes Naw-Ruz with a fixed Tehran offset, without time zone data" do
      # Dates as in spec/fixtures/bahai_org_calendar.json; published_calendar_spec
      # checks all fifty years.
      expect(Logic.nawruz_for(2026)).to eq Date.new(2026, 3, 21)
      expect(Logic.nawruz_for(2027)).to eq Date.new(2027, 3, 21)
      expect(Logic.nawruz_for(2044)).to eq Date.new(2044, 3, 20)
    end
  end
end
