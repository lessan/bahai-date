module BahaiDate
  class Weekday
    TITLES = %w(Jalal Jamal Kamal Fidal Idal Istijlal Istiqlal)
    TITLES_HTML = %w(Jalál Jamál Kamál Fiḍál ‘Idál Istijlál Istiqlál)
    TITLES_EN = %w(Glory Beauty Perfection Grace Justice Majesty Independence)
    ENGLISH_EQUIVALENTS = %w(Saturday Sunday Monday Tuesday Wednesday Thursday Friday)

    attr_reader :number

    def initialize(number_arg)
      validate number_arg
      @number = number_arg.to_i
    end

    def to_s
      title
    end

    def title
      TITLES[title_index]
    end

    def translation
      TITLES_EN[title_index]
    end

    def html
      TITLES_HTML[title_index]
    end

    def english_equivalent
      ENGLISH_EQUIVALENTS[title_index]
    end

    private

    def title_index
      @number - 1
    end

    def validate(number_arg)
      number = number_arg.to_i
      return if (1..7).include? number

      fail ArgumentError, "'#{number}' is not a valid weekday. Please use 1 to 7."
    end
  end
end
