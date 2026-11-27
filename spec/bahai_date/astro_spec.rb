module BahaiDate
  # The expected values here are the worked examples published with the
  # algorithms (Meeus, _Astronomical Algorithms_), which is what makes this a
  # check on the implementation rather than a snapshot of it.
  describe Astro do
    it "computes the vernal equinox" do
      expect(Astro.date_of_vernal_equinox(1999).to_s).to eq "1999-03-21T01:46:56+00:00"
      expect(Astro.date_of_vernal_equinox_low_accuracy(1999).to_s).to eq "1999-03-21T01:46:59+00:00"
    end

    it "computes the difference between dynamical time and UTC" do
      expect(Astro.delta_T(DateTime.new(2007, 1, 1))).to be_within(1e-9).of(65.465744703125)
    end

    it "numbers the lunations from the first new Moon of 2000" do
      expect(Astro.first_lunation_of_year(1776)).to eq(-2770)
      expect(Astro.first_lunation_of_year(2007)).to eq 87
    end

    it "computes the date of a new Moon" do
      expect(Astro.date_of_moon(87, Astro::PHASE_NEW).to_s).to eq "2007-01-19T04:01:45+00:00"
    end

    it "converts dynamical time to UTC" do
      equinox = Astro.date_of_vernal_equinox(1999)

      # ~64 seconds earlier in 1999; the sign is the point.
      expect(Astro.utc(equinox).to_s).to eq "1999-03-21T01:45:52+00:00"
    end
  end
end
