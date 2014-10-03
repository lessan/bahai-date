require 'date'

module BahaiDate

  class YearData

    LEAP_YEARS = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168]

    def self.nawruz_for(year)
      Date.new(year, 3, 21)
    end

    def self.is_leap?(year)
      LEAP_YEARS.include? year
    end

  end

end
