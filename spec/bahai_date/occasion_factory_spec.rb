require 'bahai_date/occasion_factory'

module BahaiDate
  describe OccasionFactory do

    it 'can be created given a year, month, and day' do
      occasion_factory = OccasionFactory.new(1, 1, 1)
      expect(occasion_factory).not_to be_nil
    end

    it 'provides a valid occasion for feast days' do
      occasions = OccasionFactory.new(1, 2, 1).occasions
      expect(occasions.first.type).to eq :feast
    end

    it 'provides a valid occasion for days of fasting' do
      occasions = OccasionFactory.new(1, 19, 2).occasions
      expect(occasions.first.type).to eq :fasting
    end

    it 'provides a valid occasion for days during ayyam-i-ha' do
      occasions = OccasionFactory.new(1, -1, 1).occasions
      expect(occasions.first.type).to eq :ayyam_i_ha
    end

    it 'provides a valid occasion for days during the festival of ridvan' do
      occasions = OccasionFactory.new(1, 2, 14).occasions
      expect(occasions.first.type).to eq :ridvan
    end

    it 'provides a valid occasion for holy days' do
      occasions = OccasionFactory.new(1, 1, 1).occasions
      expect(occasions.first.type).to eq :holy
    end

    it 'provides valid occasions when more than one occurs on the same day' do
      occasions = OccasionFactory.new(1, 1, 1).occasions
      expect(occasions.size).to be 2
      expect(occasions.first.type).to eq :holy
      expect(occasions.last.type).to eq :feast
    end

    context 'for dates before 172 B.E.' do
      it 'provides the Declaration of the Bab on the correct day' do
        occasions = OccasionFactory.new(1, 4, 7).occasions
        expect(occasions.first.short_title).to eq 'Declaration of the Bab'

        occasions = OccasionFactory.new(1, 4, 8).occasions
        expect(occasions.size).to be 0
      end

      it 'provides the Martyrdom of the Bab on the correct day' do
        occasions = OccasionFactory.new(1, 6, 16).occasions
        expect(occasions.first.short_title).to eq 'Martyrdom of the Bab'
      end

      it 'provides the Birth of the Bab on the correct day' do
        occasions = OccasionFactory.new(1, 12, 5).occasions
        expect(occasions.first.short_title).to eq 'Birth of the Bab'
      end

      it "provides the Birth of Baha'u'llah on the correct day" do
        occasions = OccasionFactory.new(1, 13, 9).occasions
        expect(occasions.first.short_title).to eq "Birth of Baha'u'llah"
      end
    end

    context 'for dates after 172 B.E.' do
      it 'provides the Declaration of the Bab on the correct day' do
        occasions = OccasionFactory.new(172, 4, 7).occasions
        expect(occasions.size).to be 0

        occasions = OccasionFactory.new(172, 4, 8).occasions
        expect(occasions.first.short_title).to eq 'Declaration of the Bab'
      end

      it 'provides the Martyrdom of the Bab on the correct day' do
        occasions = OccasionFactory.new(172, 6, 17).occasions
        expect(occasions.first.short_title).to eq 'Martyrdom of the Bab'
      end

      it 'provides the Birth of the Bab on the correct day' do
        occasions = OccasionFactory.new(172, 13, 10).occasions
        expect(occasions.first.short_title).to eq 'Birth of the Bab'
      end

    end

  end
end
