module BahaiDate
  describe YearCalendar do
    subject(:year_calendar) { YearCalendar.new(1) }

    it 'can be created' do
      expect(year_calendar).not_to be_nil
    end

    it 'is an instance of year' do
      expect(year_calendar).to be_a Year
    end

    it 'has months set' do
      months = year_calendar.months
      expect(months.size).to be 20
      expect(months[-1]).not_to be_nil
      expect(months[1]).not_to be_nil
      expect(months[19]).not_to be_nil
    end

    it 'has days set' do
      days = year_calendar.months[1].days
      expect(days.size).to be 19
      expect(days[1]).not_to be_nil
      expect(days[19]).not_to be_nil
    end

    it 'has weekdays set' do
      day = year_calendar.months[1].days[1]
      expect(day.weekday).not_to be_nil
      expect(day.weekday.number).to be 6
    end

    it 'has occasions set' do
      day = year_calendar.months[1].days[1]
      expect(day.occasions.size).to be 2
    end
  end
end
