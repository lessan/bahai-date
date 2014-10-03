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

    context "when converting to a gregorian date" do

      it "handles the first day of the calendar" do
        gregorian_date = BahaiDate.to_gregorian(1, 1, 1)
        expect(gregorian_date).to eq(Date.new(1844,3,21))
      end

      it "handles the last day of the year" do
        gregorian_date = BahaiDate.to_gregorian(1, 19, 19)
        expect(gregorian_date).to eq(Date.new(1845,3,20))
      end

      it "handles the year component" do
        gregorian_date = BahaiDate.to_gregorian(2, 1, 1)
        expect(gregorian_date).to eq(Date.new(1845,3,21))
      end

      context "in a leap year" do
        it "handles the day before Ayyam-i-Ha" do
          gregorian_date = BahaiDate.to_gregorian(168, 18, 19)
          expect(gregorian_date).to eq(Date.new(2012,2,25))
        end

        it "handles the first day of Ayyam-i-Ha" do
          gregorian_date = BahaiDate.to_gregorian(168, -1, 1)
          expect(gregorian_date).to eq(Date.new(2012,2,26))
        end

        it "handles the last day of Ayyam-i-Ha" do
          gregorian_date = BahaiDate.to_gregorian(168, -1, 5)
          expect(gregorian_date).to eq(Date.new(2012,3,1))
        end

        it "handles the first day of the month after Ayyam-i-Ha" do
          gregorian_date = BahaiDate.to_gregorian(168, 19, 1)
          expect(gregorian_date).to eq(Date.new(2012,3,2))
        end
      end

      context "in a non-leap year" do
        it "handles the last day of Ayyam-i-Ha" do
          gregorian_date = BahaiDate.to_gregorian(169, -1, 4)
          expect(gregorian_date).to eq(Date.new(2013,3,1))
        end
      end

    end


    context "when converting from gregorian date" do

      it "handles the first day of the calendar" do
         year, month, day = BahaiDate.from_gregorian(Date.new(1844,3,21))
         expect(year).to be 1
         expect(month).to be 1
         expect(day).to be 1
      end

      it "handles the last day of the year" do
        year, month, day = BahaiDate.from_gregorian(Date.new(1845,3,20))
        expect(year).to be 1
        expect(month).to be 19
        expect(day).to be 19
      end

      it "handles the year component" do
        year, month, day = BahaiDate.from_gregorian(Date.new(1845,3,21))
        expect(year).to be 2
        expect(month).to be 1
        expect(day).to be 1
      end

      context "in a leap year" do
        it "handles the day before Ayyam-i-Ha" do
          year, month, day = BahaiDate.from_gregorian(Date.new(2012,2,25))
          expect(year).to be 168
          expect(month).to be 18
          expect(day).to be 19
        end

        it "handles the first day of Ayyam-i-Ha" do
          year, month, day = BahaiDate.from_gregorian(Date.new(2012,2,26))
          expect(year).to be 168
          expect(month).to be -1
          expect(day).to be 1
        end

        it "handles the last day of Ayyam-i-Ha" do
          year, month, day = BahaiDate.from_gregorian(Date.new(2012,3,1))
          expect(year).to be 168
          expect(month).to be -1
          expect(day).to be 5
        end

        it "handles the first day of the month after Ayyam-i-Ha" do
          year, month, day = BahaiDate.from_gregorian(Date.new(2012,3,2))
          expect(year).to be 168
          expect(month).to be 19
          expect(day).to be 1
        end
      end

      context "in a non-leap year" do
        it "handles the last day of Ayyam-i-Ha" do
          year, month, day = BahaiDate.from_gregorian(Date.new(2013,3,1))
          expect(year).to be 169
          expect(month).to be -1
          expect(day).to be 4
        end
      end

    end

    it "can get weekday from a gregorian date accurately" do
      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,21))
      expect(weekday).to be 6

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,22))
      expect(weekday).to be 7

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,23))
      expect(weekday).to be 1

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,24))
      expect(weekday).to be 2

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,25))
      expect(weekday).to be 3

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,26))
      expect(weekday).to be 4

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,27))
      expect(weekday).to be 5

      weekday = BahaiDate.weekday_from_gregorian(Date.new(1844,3,28))
      expect(weekday).to be 6
   end

  end

end
