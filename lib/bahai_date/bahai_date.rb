module BahaiDate
  class BahaiDate
    AYYAM_I_HA = -1

    attr_reader :weekday, :day, :month, :year, :gregorian_date, :occasions

    def initialize(params)
      if params[:date]
        @gregorian_date = params[:date]
        year, month, day = from_gregorian
        @year = Year.new(year)
        @month = Month.new(month)
        @day = Day.new(day)
      elsif params[:year] && params[:month] && params[:day]
        @year = Year.new(params[:year])
        @month = Month.new(params[:month])
        @day = Day.new(params[:day])
        validate_ayyam_i_ha
        @gregorian_date = to_gregorian
      else
        fail ArgumentError, 'Invalid arguments. Use a hash with :date or with :year, :month, and :day.'
      end
      @weekday = Weekday.new(weekday_from_gregorian)
      @occasions = OccasionFactory.new(@year.bahai_era, @month.number, @day.number).occasions
    end

    def to_s
      "#{@year.bahai_era}.#{@month.number}.#{@day.number}"
    end

    def long_format
      "#{@weekday} #{@day.number} #{@month} #{@year.bahai_era} B.E."
    end

    def next_day!
      initialize(date: @gregorian_date + 1)
    end

    private

    def validate_ayyam_i_ha
      fail ArgumentError, "'#{@day.number}' is not a valid day for Ayyam-i-Ha in the year #{@year.bahai_era}" if @month.number == AYYAM_I_HA && @day.number > ayyam_i_ha_days
    end

    def ayyam_i_ha_days(year = @year.bahai_era)
      YearData.leap?(year) ? 5 : 4
    end

    def to_gregorian
      year_gregorian = @year.bahai_era + 1844 - 1
      nawruz = YearData.nawruz_for(year_gregorian)
      nawruz + days_from_nawruz
    end

    def from_gregorian
      nawruz = YearData.nawruz_for(@gregorian_date.year)

      year = @gregorian_date.year - 1844
      if @gregorian_date >= nawruz
        year += 1
        days = (@gregorian_date - nawruz).to_i
      else
        days = (@gregorian_date - YearData.nawruz_for(@gregorian_date.year - 1)).to_i
      end

      # determine day and month, taking into account ayyam-i-ha
      if days >= 342
        if days < (342 + ayyam_i_ha_days(year))
          month = AYYAM_I_HA
          day = days - 342
        else
          month = 19
          day = days - (342 + ayyam_i_ha_days(year))
        end
      else
        month, day = (days).divmod(19)
        month += 1
      end
      day += 1
      [year, month, day]
    end

    def weekday_from_gregorian
      # saturday (6 in ruby) is the first day of the week
      @gregorian_date.wday == 6 ? 1 : @gregorian_date.wday + 2
    end

    def days_from_nawruz
      days = @day.number - 1
      full_months = @month.number - 1
      full_months = 18 if @month.number == AYYAM_I_HA
      days += full_months * 19
      days += ayyam_i_ha_days if @month.number == 19
      days
    end
  end
end
