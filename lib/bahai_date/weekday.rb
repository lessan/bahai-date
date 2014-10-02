module BahaiDate

  class Weekday
    TITLES = %w[Jalal Jamal Kamal Fidal Idal Istijlal Istiqlal]
    TITLES_EN = %w[Glory Beauty Perfection Grace Justice Majesty Independence]
    ENGLISH_EQUIVALENTS = %w[Saturday Sunday Monday Tuesday Wednesday Thursday Friday]
    
    attr_reader :number, :title, :title_en, :english_equivalent

    def initialize(number_arg)
      validate number_arg
      @number = number_arg.to_i
      @title = TITLES[@number - 1]
      @title_en = TITLES_EN[@number - 1]
      @english_equivalent = ENGLISH_EQUIVALENTS[@number - 1]
    end

  private

    def validate(number_arg)
      number = number_arg.to_i
      if (number < 1 || number > 7)
        raise ArgumentError, "'#{number}' is not a valid weekday. Please use 1 to 7."
      end
     end
  end

end
