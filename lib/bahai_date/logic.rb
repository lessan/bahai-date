require 'bundler/setup'
require 'tzinfo'
require 'solareventcalculator'
require 'astro-algo'

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
    TEHRAN_LAT = BigDecimal.new('35.696111')
    TEHRAN_LONG = BigDecimal.new('51.423056')

    # *** Azimuth (for determining sunset times) ***
    # Source: http://www.timeanddate.com/astronomy/about-sun-calculator.html
    #         "Technically, sunrise and sunset are calculated based on the true geocentric position of the Sun at 90°50' from the zenith position (directly above the observer)."
    # Converted to decimal using:
    #         http://www.satsig.net/degrees-minutes-seconds-calculator.htm
    AZIMUTH = 90.833333

    def initialize
      @tz = TZInfo::Timezone.get('Asia/Tehran')
    end

    def self.nawruz_for(year)
      self.new.nawruz_date year
    end

    def self.leap?(year)
      self.new.leap? year
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
      increment_if_after_sunset localize(Astro.date_of_vernal_equinox(year).to_utc)
    end

    def twin_holy_days_for(year)
      increment_if_after_sunset(eighth_new_moon_for(year)) + 1
    end

    def eighth_new_moon_for(year)
      nawruz = nawruz_time(year)
      lunation = Astro.first_lunation_of_year(year)
      lunation += 1 while new_moon(lunation) <= nawruz
      new_moon(lunation + 7)
    end

    def new_moon(lunation)
      localize(Astro.date_of_moon(lunation, Astro::PhaseNew).to_utc)
    end

    def leap?(year)
      gregorian_year = bahai_era_to_gregorian_year(year)
      if gregorian_year < 2015
        Date.leap? gregorian_year + 1
      else
        leap_bahai_era? gregorian_year
      end
    end

    def leap_bahai_era?(year)
      (nawruz_date(year + 1) - nawruz_date(year)) == 366
    end

    def bahai_era_to_gregorian_year(year)
      1843 + year
    end

    private

    def localize(time)
      (@tz.utc_to_local(time)).to_time
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
