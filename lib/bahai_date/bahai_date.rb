require 'date'
require_relative 'year'
require_relative 'month'
require_relative 'day'
require_relative 'weekday'
require_relative 'year_data'

module BahaiDate

  class BahaiDate

    AYYAM_I_HA = -1

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
      days = self.days_from_nawruz(year, month, day)
      
      year_gregorian = year + 1844 - 1
      nawruz = YearData.nawruz_for(year_gregorian)

      nawruz + days
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
        ayyam_i_ha_days = YearData.is_leap?(year) ? 5 : 4
        if days < (342 + ayyam_i_ha_days)
          month = AYYAM_I_HA
          day = days - 342
        else
          month = 19
          day = days - (342 + ayyam_i_ha_days)
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

    def self.days_from_nawruz(year, month, day)
      days = day - 1

      full_months = month - 1
      if month == AYYAM_I_HA
        full_months = 18
      end
      days += full_months * 19
    
      if month == 19
        ayyam_i_ha_days = YearData.is_leap?(year) ? 5 : 4
        days += ayyam_i_ha_days
      end

      days
    end

  end

end
