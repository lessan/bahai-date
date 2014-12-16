module BahaiDate
  describe Logic do
    it 'supplies a Date object for Naw Ruz of a given year' do
      expect(Logic.nawruz_for(1844)).to eq(Date.new(1844, 3, 21))
    end

    it 'determines whether a year is leap or not' do
      expect(Logic.leap?(1)).to eq(false)
      expect(Logic.leap?(4)).to eq(true)
      expect(Logic.leap?(168)).to eq(true)
    end
  end
end
