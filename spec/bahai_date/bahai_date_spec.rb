require 'bahai_date/bahai_date'

module BahaiDate

  describe BahaiDate do

    it "can be created using the initializer" do
      bahai_date = BahaiDate.new(1, 1, 1, Date.today)

      expect(bahai_date).to_not be_nil
    end

    it "can be created from a Year, Month and Day" do
      bahai_date = BahaiDate.new_from_YMD(1, 1, 1)

      expect(bahai_date).to_not be_nil
    end

    it "can be created from a gregorian Date object" do
      bahai_date = BahaiDate.new_from_Date(Date.new(2010, 1, 1))

      expect(bahai_date).to_not be_nil
    end

    it "exposes various attributes" do
      bahai_date = BahaiDate.new_from_YMD(1, 1, 1)

      expect(bahai_date.weekday).to be_an_instance_of(Weekday) 
      expect(bahai_date.day).to be_an_instance_of(Day) 
      expect(bahai_date.month).to be_an_instance_of(Month) 
      expect(bahai_date.year).to be_an_instance_of(Year) 
      expect(bahai_date.gregorian_date).to be_an_instance_of(Date)
    end

    it "can convert from a gregorian date" do
      gregorian_date = BahaiDate.to_gregorian(1, 1, 1)

      expect(gregorian_date).to be_an_instance_of(Date)
      expect(gregorian_date).to eq(Date.new(1844,5,23))
    end

    it "can convert to a gregorian date" do
      year, month, day = BahaiDate.from_gregorian(Date.new(1844,5,23))

      expect(year).to eq(1)
      expect(month).to eq(1)
      expect(day).to eq(1)
    end

    it "can get weekday from a gregorian date accurately" do
      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,23))
      expect(weekday).to eq(6)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,24))
      expect(weekday).to eq(7)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,25))
      expect(weekday).to eq(1)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,26))
      expect(weekday).to eq(2)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,27))
      expect(weekday).to eq(3)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,28))
      expect(weekday).to eq(4)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,29))
      expect(weekday).to eq(5)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,5,30))
      expect(weekday).to eq(6)
   end
  end

end
