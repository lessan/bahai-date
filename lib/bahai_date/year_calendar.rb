require_relative 'year'
require_relative 'bahai_date'

module BahaiDate

  class YearCalendar < Year

    def initialize(number_arg)
      super
      populate_calendar
    end

  private

    def populate_calendar
      date = BahaiDate.new(year: @bahai_era, month: 1, day: 1)
      while date.year.bahai_era == @bahai_era do
        add_to_calendar date
        date.next_day!
      end
    end
    
    def add_to_calendar(date)
      month = set_month date.month.number
      day = month.set_day date.day.number
      day.set_weekday date.weekday
      day.set_occasions date.occasions
    end

  end

end
