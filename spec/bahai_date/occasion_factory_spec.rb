module BahaiDate
  describe OccasionFactory do
    it "can be created given a year, month, and day" do
      occasion_factory = OccasionFactory.new(1, 1, 1)
      expect(occasion_factory).not_to be_nil
    end

    it "provides a valid occasion for feast days" do
      occasions = OccasionFactory.new(1, 2, 1).occasions
      expect(occasions.first.type).to eq :feast
    end

    it "provides a valid occasion for days of fasting" do
      occasions = OccasionFactory.new(1, 19, 2).occasions
      expect(occasions.first.type).to eq :fasting
    end

    it "provides a valid occasion for days during ayyam-i-ha" do
      occasions = OccasionFactory.new(1, -1, 1).occasions
      expect(occasions.first.type).to eq :ayyam_i_ha
    end

    it "provides a valid occasion for days during the festival of ridvan" do
      occasions = OccasionFactory.new(1, 2, 14).occasions
      expect(occasions.first.type).to eq :ridvan
    end

    it "provides a valid occasion for holy days" do
      occasions = OccasionFactory.new(1, 1, 1).occasions
      expect(occasions.first.type).to eq :holy
    end

    it "provides valid occasions when more than one occurs on the same day" do
      occasions = OccasionFactory.new(1, 1, 1).occasions
      expect(occasions.size).to be 2
      expect(occasions.first.type).to eq :holy
      expect(occasions.last.type).to eq :feast
    end

    context "for dates before 172 B.E." do
      it "provides the Declaration of the Bab on the correct day" do
        occasions = OccasionFactory.new(1, 4, 7).occasions
        expect(occasions.first.short_title).to eq "Declaration of the Bab"

        occasions = OccasionFactory.new(1, 4, 8).occasions
        expect(occasions.size).to be 0
      end

      it "provides the Martyrdom of the Bab on the correct day" do
        occasions = OccasionFactory.new(1, 6, 16).occasions
        expect(occasions.first.short_title).to eq "Martyrdom of the Bab"
      end

      it "provides the Birth of the Bab on the correct day" do
        occasions = OccasionFactory.new(1, 12, 5).occasions
        expect(occasions.first.short_title).to eq "Birth of the Bab"
      end

      it "provides the Birth of Baha'u'llah on the correct day" do
        occasions = OccasionFactory.new(1, 13, 9).occasions
        expect(occasions.first.short_title).to eq "Birth of Baha'u'llah"
      end

      it "can find the month and day for a given occasion on a given year" do
        month_and_day = OccasionFactory.find(:birth_bab, 163)
        expect(month_and_day).to eq "12.5"
      end
    end

    context "Ayyam-i-ha date ranges" do
      it "Finds the date range for Ayyam-i-ha" do
        range = OccasionFactory.ayyam_i_ha_range(180)
        expect(range.first).to eq(Date.parse("2024-02-26"))
        expect(range.last).to eq(Date.parse("2024-02-29"))
        expect(range.to_a.length).to eq(4)
      end

      it "Finds the date range for Ayyam-i-ha for the current year" do
        range = OccasionFactory.ayyam_i_ha_range(187)
        expect(range.first).to eq(Date.parse("2031-02-25"))
        expect(range.last).to eq(Date.parse("2031-03-01"))
        expect(range.to_a.length).to eq(5)
      end
    end

    context "Fasting date ranges" do
      it "Finds the date range for Fasting month" do
        range = OccasionFactory.fasting_range(180)
        expect(range.first).to eq(Date.parse("2024-03-01"))
        expect(range.last).to eq(Date.parse("2024-03-19"))
      end

      it "Finds the date range for Fasting month leap year" do
        range = OccasionFactory.fasting_range(187)
        expect(range.first).to eq(Date.parse("2031-03-02"))
        expect(range.last).to eq(Date.parse("2031-03-20"))
      end
    end

    context "for dates after 172 B.E." do
      it "provides the Declaration of the Bab on the correct day" do
        occasions = OccasionFactory.new(172, 4, 7).occasions
        expect(occasions.size).to be 0

        occasions = OccasionFactory.new(172, 4, 8).occasions
        expect(occasions.first.short_title).to eq "Declaration of the Bab"
      end

      it "provides the Martyrdom of the Bab on the correct day" do
        occasions = OccasionFactory.new(172, 6, 17).occasions
        expect(occasions.first.short_title).to eq "Martyrdom of the Bab"
      end

      it "provides the Birth of the Bab on the correct day" do
        occasions = OccasionFactory.new(172, 13, 10).occasions
        expect(occasions.first.short_title).to eq "Birth of the Bab"
      end

      it "can find the month and day for a given occasion on a given year" do
        month_and_day = OccasionFactory.find(:birth_bab, 173)
        expect(month_and_day).to eq "12.18"
      end
    end
  end
end
