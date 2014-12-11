module BahaiDate
  class YearCalendar < Year
    def initialize(number_arg)
      super
      populate_calendar
    end

    private

    def populate_calendar
      date = BahaiDate.new(year: @bahai_era, month: 1, day: 1)
      while date.year.bahai_era == @bahai_era
        add_to_calendar date
        date.next_day!
      end
    end

    def add_to_calendar(date)
      month = add_month date.month.number
      day = month.add_day date.day.number
      day.weekday = date.weekday
      day.occasions = date.occasions
    end
  end
end
