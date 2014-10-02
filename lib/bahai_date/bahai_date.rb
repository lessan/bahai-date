require 'date'
require_relative 'year'
require_relative 'month'
require_relative 'day'
require_relative 'weekday'

module BahaiDate

  class BahaiDate
    attr_reader :weekday, :day, :month, :year, :gregorian_date

    def initialize(params)
      if params[:date]
        parse_Date params[:date]
      elsif params[:year] and params[:month] and params[:day]
        parse_YMD params[:year], params[:month], params[:day]
      else
        raise ArgumentError, "Invalid arguments. Use a hash with :date or with :year, :month, and :day."
      end
    end

    def parse_YMD(year, month, day)
      gregorian_date = self.class.to_gregorian(year, month, day)
      set_attributes(year, month, day, gregorian_date)
    end

    def parse_Date(date)
      year, month, day = self.class.from_gregorian(date)
      set_attributes(year, month, day, date)
    end

    def set_attributes(year, month, day, gregorian_date)
      @gregorian_date = gregorian_date
      @year = Year.new(year)
      @month = Month.new(month)
      @day = Day.new(day)
      @weekday = Weekday.new(self.class.weekday_from_gregorian(@gregorian_date))
    end

    def self.to_gregorian(year, month, day)
      Date.new(1844,3,21)
    end

    def self.from_gregorian(date)
      nawruz = YearData.nawruz_for(date.year)

      year = date.year - 1844
      if date >= nawruz then
        year += 1
        days = (date - nawruz).to_i
      else
        days = (date - YearData.nawruz_for(date.year - 1)).to_i
      end
 
      # determine day and month, taking into account ayyam-i-ha
      if days >= 342
        ayyam_i_ha = YearData.is_leap?(year) ? 5 : 4
        if days < (342 + ayyam_i_ha)
          month = -1
          day = days - 342
        else
          month = 19
          day = days - (342 + ayyam_i_ha)
        end
      else
        month, day = (days).divmod(19)
        month += 1
      end
      day += 1
      [year, month, day]
    end

    def self.weekday_from_gregorian(date)
      # saturday (6 in ruby) is the first day of the week
      date.wday == 6 ? 1 : date.wday + 2
    end

  end


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
