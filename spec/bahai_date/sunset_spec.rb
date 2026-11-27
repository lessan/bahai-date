module BahaiDate
  describe Sunset do
    # Times from RubySunrise 0.3.3, which this module replaces.
    {
      Date.new(2026, 3, 20) => "14:45",
      Date.new(2026, 6, 21) => "15:53",
      Date.new(2026, 12, 21) => "13:24",
      Date.new(2418, 3, 20) => "14:45"
    }.each do |date, utc|
      it "gives sunset in Tehran on #{date} at #{utc} UTC, as RubySunrise did" do
        sunset = Sunset.utc(date, Logic::TEHRAN_LAT, Logic::TEHRAN_LONG)

        expect(sunset.utc?).to be true
        expect(sunset.to_date).to eq date
        expect(sunset.strftime("%H:%M:%S")).to eq "#{utc}:00"
      end
    end

    it "returns nil when the Sun does not set" do
      expect(Sunset.utc(Date.new(2026, 6, 21), 78.2, 15.6)).to be_nil
    end
  end
end
