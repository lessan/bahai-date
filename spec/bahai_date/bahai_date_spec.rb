require 'bahai_date/bahai_date'

module BahaiDate

  describe BahaiDate do

    it "can be created from a Year, Month and Day" do
      bahai_date = BahaiDate.new(year: 1, month: 1, day: 1)

      expect(bahai_date).to_not be_nil
    end

    it "can be created from a gregorian Date object" do
      bahai_date = BahaiDate.new(date: Date.new(2010, 1, 1))

      expect(bahai_date).to_not be_nil
    end

    it "raises an error if invalid arguments are passed to the initializer" do
      expect { BahaiDate.new }.to raise_error(ArgumentError)
      expect { BahaiDate.new({}) }.to raise_error(ArgumentError)
      expect { BahaiDate.new(day: 1) }.to raise_error(ArgumentError)
    end


    it "exposes various attributes" do
      bahai_date = BahaiDate.new(year: 1, month: 1, day: 1)

      expect(bahai_date.weekday).to be_an_instance_of(Weekday) 
      expect(bahai_date.day).to be_an_instance_of(Day) 
      expect(bahai_date.month).to be_an_instance_of(Month) 
      expect(bahai_date.year).to be_an_instance_of(Year) 
      expect(bahai_date.gregorian_date).to be_an_instance_of(Date)
    end

    it "can convert to a gregorian date" do
      gregorian_date = BahaiDate.to_gregorian(1, 1, 1)

      expect(gregorian_date).to be_an_instance_of(Date)
      expect(gregorian_date).to eq(Date.new(1844,3,21))
    end

    it "can convert from a gregorian date" do
      year, month, day = BahaiDate.from_gregorian(Date.new(1844,3,21))
      expect(year).to eq(1)
      expect(month).to eq(1)
      expect(day).to eq(1)

      year, month, day = BahaiDate.from_gregorian(Date.new(1845,3,20))
      expect(year).to eq(1)
      expect(month).to eq(19)
      expect(day).to eq(19)

      year, month, day = BahaiDate.from_gregorian(Date.new(1845,3,21))
      expect(year).to eq(2)
      expect(month).to eq(1)
      expect(day).to eq(1)

      year, month, day = BahaiDate.from_gregorian(Date.new(2012,2,25))
      expect(year).to eq(168)
      expect(month).to eq(18)
      expect(day).to eq(19)
 
      year, month, day = BahaiDate.from_gregorian(Date.new(2012,2,26))
      expect(year).to eq(168)
      expect(month).to eq(-1)
      expect(day).to eq(1)

      year, month, day = BahaiDate.from_gregorian(Date.new(2012,3,1))
      expect(year).to eq(168)
      expect(month).to eq(-1)
      expect(day).to eq(5)

      year, month, day = BahaiDate.from_gregorian(Date.new(2012,3,2))
      expect(year).to eq(168)
      expect(month).to eq(19)
      expect(day).to eq(1)

      year, month, day = BahaiDate.from_gregorian(Date.new(2013,3,1))
      expect(year).to eq(169)
      expect(month).to eq(-1)
      expect(day).to eq(4)
    end

    it "can get weekday from a gregorian date accurately" do
      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,21))
      expect(weekday).to eq(6)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,22))
      expect(weekday).to eq(7)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,23))
      expect(weekday).to eq(1)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,24))
      expect(weekday).to eq(2)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,25))
      expect(weekday).to eq(3)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,26))
      expect(weekday).to eq(4)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,27))
      expect(weekday).to eq(5)

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,28))
      expect(weekday).to eq(6)
   end
  end

  describe YearData do

    it "determines whether a year is leap or not" do
      expect(YearData.is_leap?(1)).to eq(false)
      expect(YearData.is_leap?(4)).to eq(true)
      expect(YearData.is_leap?(168)).to eq(true)
    end

  end
end
