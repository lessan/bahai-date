module BahaiDate
  describe Logic do
    it 'supplies a Date object for Naw Ruz of a given year' do
      expect(Logic.nawruz_for(1844)).to eq(Date.new(1844, 3, 21))
    end

    it 'determines whether a year is leap or not' do
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
  end
end
