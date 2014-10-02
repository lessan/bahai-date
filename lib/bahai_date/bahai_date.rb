require 'date'

module BahaiDate

  class BahaiDate
    attr_reader :weekday, :day, :month, :year, :gregorian_date

    def self.new_from_YMD(year, month, day)
      gregorian_date = to_gregorian(year, month, day)
      self.new(year, month, day, gregorian_date)
    end

    def self.new_from_Date(date)
      year, month, day = from_gregorian(@gregorian_date)
      self.new(year, month, day, date)
    end

    def initialize(year, month, day, gregorian_date)
      @gregorian_date = gregorian_date
      @year = Year.new(year)
      @month = Month.new(month)
      @day = Day.new(day)
      @weekday = Weekday.new(self.class.weekday_from_gregorian(@gregorian_date))
    end

    def self.to_gregorian(year, month, day)
      Date.new(1844,5,23)
    end

    def self.from_gregorian(date)
      [1, 1, 1]
    end

    def self.weekday_from_gregorian(date)
      # saturday (6 in ruby) is the first day of the week
      date.wday == 6 ? 1 : date.wday + 2
    end

  end

end
