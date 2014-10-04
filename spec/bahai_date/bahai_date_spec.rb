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

    context "when validating the Baha'i Era date" do

      context "year" do
        it "raises an error if less than 1" do
          expect { BahaiDate.new(year: 0, month: 1, day: 1) 
                 }.to raise_error(ArgumentError)
        end
      end

      context "month" do
        it "raises an error if 0" do
           expect { BahaiDate.new(year: 1, month: 0, day: 1)
                  }.to raise_error(ArgumentError)
        end
        it "raises an error if less than -1" do
           expect { BahaiDate.new(year: 1, month: -2, day: 1)
                  }.to raise_error(ArgumentError)
        end
        it "raises an error if greater than 19" do
           expect { BahaiDate.new(year: 1, month: 20, day: 1) 
                  }.to raise_error(ArgumentError)
        end
      end

      context "day" do
        it "raises an error if less than 1" do
           expect { BahaiDate.new(year: 1, month: 1, day: 0)
                  }.to raise_error(ArgumentError)
        end
        it "raises an error if greater than 19" do
           expect { BahaiDate.new(year: 1, month: 1, day: 20) 
                  }.to raise_error(ArgumentError)
        end
        context "in Ayyam-i-Ha" do
          it "raises an error if greater than 4 on a non-leap year" do
             expect { BahaiDate.new(year: 1, month: -1, day: 5)
                    }.to raise_error(ArgumentError)
          end
          it "doesn't raise an error if 5 on a leap year" do
             expect { BahaiDate.new(year: 4, month: -1, day: 5) 
                    }.not_to raise_error
          end
          it "raises an error if greater than 5 on a leap year" do
             expect { BahaiDate.new(year: 4, month: -1, day: 6) 
                    }.to raise_error(ArgumentError)
          end
        end
      end

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
        bahai_date = BahaiDate.new(year: 1, month: 1, day: 1)
        expect(bahai_date.gregorian_date).to eq(Date.new(1844,3,21))
      end

      it "handles the last day of the year" do
        bahai_date = BahaiDate.new(year: 1, month: 19, day: 19)
        expect(bahai_date.gregorian_date).to eq(Date.new(1845,3,20))
      end

      it "handles the year component" do
        bahai_date = BahaiDate.new(year: 2, month: 1, day: 1)
        expect(bahai_date.gregorian_date).to eq(Date.new(1845,3,21))
      end

      context "in a leap year" do
        it "handles the day before Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(year: 168, month: 18, day: 19)
          expect(bahai_date.gregorian_date).to eq(Date.new(2012,2,25))
        end

        it "handles the first day of Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(year: 168, month: -1, day: 1)
          expect(bahai_date.gregorian_date).to eq(Date.new(2012,2,26))
        end

        it "handles the last day of Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(year: 168, month: -1, day: 5)
          expect(bahai_date.gregorian_date).to eq(Date.new(2012,3,1))
        end

        it "handles the first day of the month after Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(year: 168, month: 19, day: 1)
          expect(bahai_date.gregorian_date).to eq(Date.new(2012,3,2))
        end
      end

      context "in a non-leap year" do
        it "handles the last day of Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(year: 169, month: -1, day: 4)
          expect(bahai_date.gregorian_date).to eq(Date.new(2013,3,1))
        end
      end

    end


    context "when converting from gregorian date" do

      it "handles the first day of the calendar" do
         bahai_date = BahaiDate.new(date: Date.new(1844,3,21))
         expect(bahai_date.year.bahai_era).to be 1
         expect(bahai_date.month.number).to be 1
         expect(bahai_date.day.number).to be 1
      end

      it "handles the last day of the year" do
        bahai_date = BahaiDate.new(date: Date.new(1845,3,20))
        expect(bahai_date.year.bahai_era).to be 1
        expect(bahai_date.month.number).to be 19
        expect(bahai_date.day.number).to be 19
      end

      it "handles the year component" do
        bahai_date = BahaiDate.new(date: Date.new(1845,3,21))
        expect(bahai_date.year.bahai_era).to be 2
        expect(bahai_date.month.number).to be 1
        expect(bahai_date.day.number).to be 1
      end

      context "in a leap year" do
        it "handles the day before Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(date: Date.new(2012,2,25))
          expect(bahai_date.year.bahai_era).to be 168
          expect(bahai_date.month.number).to be 18
          expect(bahai_date.day.number).to be 19
        end

        it "handles the first day of Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(date: Date.new(2012,2,26))
          expect(bahai_date.year.bahai_era).to be 168
          expect(bahai_date.month.number).to be -1
          expect(bahai_date.day.number).to be 1
        end

        it "handles the last day of Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(date: Date.new(2012,3,1))
          expect(bahai_date.year.bahai_era).to be 168
          expect(bahai_date.month.number).to be -1
          expect(bahai_date.day.number).to be 5
        end

        it "handles the first day of the month after Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(date: Date.new(2012,3,2))
          expect(bahai_date.year.bahai_era).to be 168
          expect(bahai_date.month.number).to be 19
          expect(bahai_date.day.number).to be 1
        end
      end

      context "in a non-leap year" do
        it "handles the last day of Ayyam-i-Ha" do
          bahai_date = BahaiDate.new(date: Date.new(2013,3,1))
          expect(bahai_date.year.bahai_era).to be 169
          expect(bahai_date.month.number).to be -1
          expect(bahai_date.day.number).to be 4
        end
      end

    end

    it "can get weekday from a gregorian date accurately" do
      bahai_date = BahaiDate.new(date: Date.new(1844,3,21))
      expect(bahai_date.weekday.number).to be 6

      bahai_date = BahaiDate.new(date: Date.new(1844,3,22))
      expect(bahai_date.weekday.number).to be 7

      bahai_date = BahaiDate.new(date: Date.new(1844,3,23))
      expect(bahai_date.weekday.number).to be 1

      bahai_date = BahaiDate.new(date: Date.new(1844,3,24))
      expect(bahai_date.weekday.number).to be 2

      bahai_date = BahaiDate.new(date: Date.new(1844,3,25))
      expect(bahai_date.weekday.number).to be 3

      bahai_date = BahaiDate.new(date: Date.new(1844,3,26))
      expect(bahai_date.weekday.number).to be 4

      bahai_date = BahaiDate.new(date: Date.new(1844,3,27))
      expect(bahai_date.weekday.number).to be 5

      bahai_date = BahaiDate.new(date: Date.new(1844,3,28))
      expect(bahai_date.weekday.number).to be 6
   end

  end

end
