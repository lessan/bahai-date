require "bigdecimal"
require "date"
require "solareventcalculator"
require "bahai_date/astro"

module BahaiDate
  class Logic
    ####
    # Note: This class uses dates in the Gregorian calendar internally, as they
    # are used by the libraries which determine leap years, the spring equinox
    # and lunar phases.
    ####

    # *** Latitude and longitude for Tehran, Iran ***
    # Source: http://mynasadata.larc.nasa.gov/latitudelongitude-finder/
    #         Latitude: 35° 41' 45.9996", Longitude: 51° 25' 23.0016"
    # Converted to decimal using:
    #         http://transition.fcc.gov/mb/audio/bickel/DDDMMSS-decimal.html
    TEHRAN_LAT = BigDecimal("35.696111")
    TEHRAN_LONG = BigDecimal("51.423056")

    # *** Azimuth (for determining sunset times) ***
    # Source: http://www.timeanddate.com/astronomy/about-sun-calculator.html
    #         "Technically, sunrise and sunset are calculated based on the true geocentric position of the Sun at 90°50' from the zenith position (directly above the observer)."
    # Converted to decimal using:
    #         http://www.satsig.net/degrees-minutes-seconds-calculator.htm
    AZIMUTH = 90.833333

    # Iran Standard Time. Tehran has kept this offset all year since it dropped
    # daylight saving in 2022, and before that daylight saving only ran from
    # late March to late September, so neither Naw-Ruz nor the new moons of the
    # Twin Holy Days ever fell in it. The offset only decides which calendar
    # date a moment is labelled with before it is compared with that date's
    # sunset, so any offset within a few hours gives the same answers; this one
    # matches the zoneinfo answers for every year from 2015 to 3001.
    TEHRAN_UTC_OFFSET = "+03:30"

    # The astronomical algorithms are good to about the year 3000, and the last
    # Baha'i year that starts by then is 1157 (it ends in March 3001).
    MAX_GREGORIAN_YEAR = 3001

    def self.nawruz_for(year)
      check_gregorian_year(year)
      # Memoised: every conversion asks for this once or twice per date, and the
      # answer for a given year cannot change within a process.
      @nawruz_dates ||= {}
      @nawruz_dates[year] ||= new.nawruz_date(year)
    end

    def self.leap?(year_bahai_era)
      Year.check(year_bahai_era)
      new.leap? year_bahai_era
    end

    def self.twin_holy_days_date(year_bahai_era)
      Year.check(year_bahai_era)
      new.twin_holy_days_for year_bahai_era
    end

    def self.check_gregorian_year(year)
      return if year.is_a?(Integer) && year <= MAX_GREGORIAN_YEAR

      fail ArgumentError, "'#{year}' is outside the supported range. Dates up to the end of the year #{Year::MAX} B.E. (March #{MAX_GREGORIAN_YEAR}) are supported."
    end

    def nawruz_date(year)
      if year < 2015
        Date.new(year, 3, 21)
      else
        spring_equinox_in_tehran(year)
      end
    end

    def nawruz_time(year)
      sunset_time_for(nawruz_date(year))
    end

    def sunset_time_for(date)
      calc = SolarEventCalculator.new(date, TEHRAN_LAT, TEHRAN_LONG)
      sunset_time = calc.compute_utc_solar_event(AZIMUTH, false)
      localize(sunset_time.utc)
    end

    def spring_equinox_in_tehran(year)
      increment_if_after_sunset localize(Astro.utc(Astro.date_of_vernal_equinox(year)))
    end

    def twin_holy_days_for(year_bahai_era)
      gregorian_year = bahai_era_to_gregorian_year(year_bahai_era)
      increment_if_after_sunset(eighth_new_moon_for(gregorian_year)) + 1
    end

    def eighth_new_moon_for(year)
      nawruz = nawruz_time(year)
      lunation = Astro.first_lunation_of_year(year)
      lunation += 1 while new_moon(lunation) <= nawruz
      new_moon(lunation + 7)
    end

    def new_moon(lunation)
      localize(Astro.utc(Astro.date_of_moon(lunation, Astro::PHASE_NEW)))
    end

    def leap?(year_bahai_era)
      gregorian_year = bahai_era_to_gregorian_year(year_bahai_era)
      if gregorian_year < 2015
        Date.leap? gregorian_year + 1
      else
        leap_bahai_era? gregorian_year
      end
    end

    def leap_bahai_era?(year)
      (self.class.nawruz_for(year + 1) - self.class.nawruz_for(year)) == 366
    end

    def bahai_era_to_gregorian_year(year)
      1843 + year
    end

    private

    def localize(time)
      time.to_time.getlocal(TEHRAN_UTC_OFFSET)
    end

    def increment_if_after_sunset(time)
      date = time.to_date
      if time > sunset_time_for(date)
        date += 1
      end
      date
    end
  end
end
