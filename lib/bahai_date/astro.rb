require "date"
require "bahai_date/astro/tables"

module BahaiDate
  # Astronomical algorithms from Jean Meeus, _Astronomical Algorithms_, 2nd
  # English Edition, Willmann-Bell, Inc., Richmond, Virginia, 1999.
  #
  # This started life as the astro-algo gem. It is now a plain module: it used
  # to reopen Numeric, Array and DateTime on load, which is not acceptable for
  # a gem that gets pulled into other applications.
  module Astro
    PHASE_NEW = 0
    PHASE_FIRST_QUARTER = 1
    PHASE_FULL = 2
    PHASE_LAST_QUARTER = 3

    # Difference between dynamical time and UTC, in seconds.
    # Good from -1999 to +3000.
    def self.delta_T(date)
      year = date.year.to_f
      y = year + (date.month.to_f - 0.5) / 12.0

      if year < -500.0
        u = (year - 1820.0) / 100.0
        -20.0 + 32.0 * u * u
      elsif year < 500.0
        poly_eval([0.0090316521, 0.022174192, -0.1798452, -5.952053, 33.78311, -1014.41, 10583.6], y / 100.0)
      elsif year < 1600.0
        poly_eval([0.0083572073, -0.005050998, -0.8503463, 0.319781, 71.23472, -556.01, 1574.2], (y - 1000.0) / 100.0)
      elsif year < 1700.0
        poly_eval([1.0 / 7129.0, -0.01532, -0.9808, 120.0], y - 1600.0)
      elsif year < 1800.0
        poly_eval([-1.0 / 1174000.0, 0.00013336, -0.0059285, 0.1603, 8.83], y - 1700.0)
      elsif year < 1860.0
        poly_eval([0.000000000875, -0.0000001699, 0.0000121272, -0.00037436, 0.0041116, 0.0068612, -0.332447, 13.72], y - 1800.0)
      elsif year < 1900.0
        poly_eval([1.0 / 233174.0, -0.0004473624, 0.01680668, -0.251754, 0.5737, 7.62], y - 1860.0)
      elsif year < 1920.0
        poly_eval([-0.000197, 0.0061966, -0.0598939, 1.494119, -2.79], y - 1900.0)
      elsif year < 1941.0
        poly_eval([0.0020936, -0.076100, 0.84493, 21.20], y - 1920.0)
      elsif year < 1961.0
        poly_eval([1.0 / 2547.0, -1.0 / 233.0, 0.407, 29.07], y - 1950.0)
      elsif year < 1986.0
        poly_eval([-1.0 / 718.0, -1.0 / 260.0, 1.067, 45.45], y - 1975.0)
      elsif year < 2005.0
        poly_eval([0.00002373599, 0.000651814, 0.0017275, -0.060374, 0.3345, 63.86], y - 2000.0)
      elsif year < 2050.0
        poly_eval([0.005589, 0.32217, 62.92], y - 2000.0)
      elsif year < 2150.0
        -20.0 + 32.0 * ((y - 1820.0) / 100.0)**2 - 0.5628 * (2150.0 - y)
      else
        u = (year - 1820.0) / 100.0
        -20.0 + 32.0 * u * u
      end
    end

    # Converts a DateTime in dynamical time to UTC. Returns a DateTime.
    def self.utc(date)
      date - delta_T(date).to_r / 86400
    end

    # Date and time of the given phase of the Moon. k is the lunation number,
    # counted from the first new Moon of the year 2000.
    def self.date_of_moon(k, phase)
      k += phase / 4.0

      # Julian centuries
      t = k / 1236.85

      # Julian ephemeris days
      jde = 2_451_550.097_66 +
        29.530_588_861 * k +
        poly_eval([0.000_000_000_73, -0.000_000_150, 0.000_154_37, 0.0, 0.0], t)

      # Eccentricity of the Earth's orbit
      e = poly_eval([-0.000_0074, -0.002_516, 1.0], t)

      # Sun's mean anomaly
      m = 2.5534 +
        29.105_356_70 * k +
        poly_eval([-0.000_000_11, -0.000_0014, 0.0, 0.0], t)

      # Moon's mean anomaly
      m_lun = 201.5643 +
        385.816_935_28 * k +
        poly_eval([-0.000_000_058, 0.000_012_38, 0.010_7582, 0.0, 0.0], t)

      # Moon's argument of latitude
      f = 160.7108 +
        390.670_502_84 * k +
        poly_eval([0.000_000_011, -0.000_002_27, -0.001_6118, 0.0, 0.0], t)

      # Longitude of the ascending node of the lunar orbit
      o = 124.7746 -
        1.563_755_88 * k +
        poly_eval([0.000_002_15, 0.002_0672, 0.0, 0.0], t)

      if phase == PHASE_NEW || phase == PHASE_FULL
        column = (phase == PHASE_NEW) ? 0 : 1
        jde += TABLE_49B.inject(0.0) do |sum, term|
          coefficient = term[column]
          term[2].times { coefficient *= e }
          angle = term[3] * f + term[4] * m + term[5] * m_lun + term[6] * o
          sum + coefficient * Math.sin(radians(angle % 360.0))
        end
      else
        jde += TABLE_49C.inject(0.0) do |sum, term|
          coefficient = term[0]
          term[1].times { coefficient *= e }
          angle = term[2] * f + term[3] * m + term[4] * m_lun + term[5] * o
          sum + coefficient * Math.sin(radians(angle % 360.0))
        end

        w = 0.00002 * Math.cos(radians(2.0 * f)) +
          0.00002 * Math.cos(radians(m_lun + m)) -
          0.00002 * Math.cos(radians(m_lun - m)) +
          0.00026 * Math.cos(radians(m_lun)) -
          0.00038 * e * Math.cos(radians(m)) +
          0.00306

        jde += (phase == PHASE_FIRST_QUARTER) ? w : -w
      end

      # Correction for all phases
      t_squared = t * t
      jde += TABLE_49A.inject(0.0) do |sum, term|
        a = term[0] + term[1] * k + term[3] * t_squared
        sum + Math.sin(radians(a % 360.0)) * term[2]
      end

      DateTime.jd(jde.to_r) + 0.5
    end

    # Number of the first lunation (new Moon) of the given year. Lunation 0 is
    # the first new Moon of the year 2000.
    def self.first_lunation_of_year(year)
      k = ((year - 2000) * 12.3685).floor
      k += 1 while date_of_moon(k, PHASE_NEW).year < year
      k
    end

    # Date and time of the vernal equinox, from the lower accuracy algorithm of
    # chapter 27. Good from about -1000 to +3000.
    def self.date_of_vernal_equinox_low_accuracy(year)
      if year >= 1000
        y = (year - 2000.0) / 1000.0
        jdme = poly_eval([-0.000_57, -0.004_11, 0.051_69, 365_242.374_04, 2_451_623.809_84], y)
      else
        y = year / 1000.0
        jdme = poly_eval([-0.000_71, 0.001_11, 0.061_34, 365_242.137_40, 1_721_139.291_89], y)
      end

      # Julian centuries from 2000
      t = (jdme - 2_451_545.0) / 36525.0

      w = radians(35_999.373 * t - 2.47)
      lambda = 1.0 + 0.0334 * Math.cos(w) + 0.0007 * Math.cos(2.0 * w)
      # Unlike the Earth tables below, this one takes its argument in degrees.
      s = TABLE_27C.inject(0.0) { |accum, (a, b, c)| accum + a * Math.cos(radians(b + c * t)) }

      DateTime.jd((jdme + 0.000_01 * s / lambda).to_r) + 0.5
    end

    # Date and time of the vernal equinox, from the higher accuracy algorithm of
    # chapter 27. Returns a DateTime in dynamical time.
    def self.date_of_vernal_equinox(year)
      est_date = date_of_vernal_equinox_low_accuracy(year)

      5.times do
        sol_long = solar_longitude(est_date)
        sol_long -= 360.0 if sol_long > 180.0
        break if sol_long.abs < 0.000001
        est_date += (58 * Math.sin(radians(-sol_long))).to_r
      end

      est_date
    end

    # Nutation in longitude of the Earth's pole for the given DateTime, in
    # degrees. Chapter 22.
    def self.nutation_in_longitude(date)
      # Julian centuries from the epoch J2000.0
      t = (date.ajd.to_f - 2451545.0) / 36525.0

      # Mean elongation of the Moon from the Sun
      d = poly_eval([1.0 / 189_474.0, -0.001_9142, 445_267.111_480, 297.85036], t) % 360.0

      # Mean anomaly of the Sun (Earth)
      m = poly_eval([-1.0 / 300_000.0, -0.000_1603, 35_999.050_340, 357.52772], t) % 360.0

      # Mean anomaly of the Moon
      m_lun = poly_eval([1.0 / 56_250.0, 0.008_6972, 477_198.867_398, 134.96298], t) % 360.0

      # Moon's argument of latitude
      f = poly_eval([1.0 / 327_270.0, -0.003_6825, 483_202.017_538, 93.27191], t) % 360.0

      # Longitude of the ascending node of the Moon's mean orbit on the ecliptic
      omega = poly_eval([1.0 / 450_000.0, 0.002_0708, -1934.136_261, 125.04452], t) % 360.0

      TABLE_22A.inject(0.0) do |nutation, term|
        angle = term[0] * d + term[1] * m + term[2] * m_lun + term[3] * f + term[4] * omega
        nutation + (term[5] + term[6] * t) * Math.sin(radians(angle)) / 36_000_000.0
      end
    end

    # Longitude of the Sun for the given DateTime, in degrees. The higher
    # accuracy algorithm of chapter 25: within 1" between -2000 and +6000.
    def self.solar_longitude(date)
      # Julian millennia from the epoch J2000.0 (2000 January 1.5 TD)
      t = (date.ajd.to_f - 2451545.0) / 365250.0

      l0 = sum_terms(EARTH_L0, t)
      l1 = sum_terms(EARTH_L1, t)
      l2 = sum_terms(EARTH_L2, t)
      l3 = sum_terms(EARTH_L3, t)
      l4 = sum_terms(EARTH_L4, t)
      l5 = sum_terms(EARTH_L5, t)
      long = poly_eval([l5, l4, l3, l2, l1, l0], t) * 1e-8 * 180.0 / Math::PI % 360.0

      r0 = sum_terms(EARTH_R0, t)
      r1 = sum_terms(EARTH_R1, t)
      r2 = sum_terms(EARTH_R2, t)
      r3 = sum_terms(EARTH_R3, t)
      r4 = sum_terms(EARTH_R4, t)
      radius = poly_eval([r4, r3, r2, r1, r0], t) * 1e-8

      long -= 180.0 # switch to the Earth's perspective
      long += -2.509167e-5 # convert to the FK5 system
      long += nutation_in_longitude(date)
      long += -0.0056916111 / radius # correct for aberration
      long % 360.0
    end

    # Sum of the periodic terms of a Meeus table of [A, B, C] rows:
    # sum(A * cos(B + C*t)). B is already an angle for the Earth tables; the
    # ones that need degrees converted (TABLE_27C) sum themselves.
    def self.sum_terms(table, t)
      table.inject(0.0) { |accumulator, (a, b, c)| accumulator + a * Math.cos(b + c * t) }
    end

    # Degrees to radians.
    def self.radians(degrees)
      degrees * Math::PI / 180.0
    end

    # Horner's method. The coefficients run from the highest order term down to
    # the constant term, as printed in the book.
    def self.poly_eval(coefficients, x)
      coefficients.inject(0.0) { |accumulator, coefficient| accumulator * x + coefficient }
    end
  end
end
