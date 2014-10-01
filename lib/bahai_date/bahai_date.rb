module BahaiDate

  class BahaiDate
    def self.fromYMD(year, month, day)
      @year = year
      @month = month
      @day = day
    end

    def self.fromDate(date)
      @gregorian_date = date
    end
  end


  class WeekDay
    TITLES = %w[Jalal Jamal Kamal Fidal Idal Istijlal Istiqlal]
    TITLES_EN = %w[Glory Beauty Perfection Grace Justice Majesty Independence]
    GREGORIAN = %w[Saturday Sunday Monday Tuesday Wednesday Thursday Friday]
    
    attr_reader :number, :title, :title_en, :gregorian

    def initialize(number_arg)
      validate number_arg
      @number = number.to_i
      @title = TITLES[@number - 1]
      @title_en = TITLES_EN[@number - 1]
      @gregorian = GREGORIAN[@number - 1]
    end

  private

    def validate(number_arg)
      number = number_arg.to_i
      if (number < 1 || number > 7)
        raise ArgumentError, "'#{number}' is not a valid week day. Please use 1 to 7."
      end
     end
  end

end
