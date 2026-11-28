module BahaiDate
  class Year
    TITLES = %w[Alif Ba Ab Dal Bab Vav Abad Jad Baha Hubb Bahhaj Javab Ahad Vahhab Vidad Badi Bahi Abha Vahid]
    TITLES_HTML = %w[Alif Bá’ Ab Dál Báb Váv Abad Jád Bahá Ḥubb Bahháj Javáb Aḥad Vahháb Vidád Badí‘ Bahí Abhá Váḥid]
    TITLES_EN = ["A", "B", "Father", "D", "Gate", "V", "Eternity", "Generosity", "Splendour", "Love", "Delightful", "Answer", "Single", "Bountiful", "Affection", "Beginning", "Luminous", "Most Luminous", "Unity"]

    # The last year this gem supports: see Logic::MAX_GREGORIAN_YEAR.
    MAX = 1157

    attr_reader :bahai_era, :number, :vahid, :kull_i_shay, :months

    def self.check(number_arg)
      number = number_arg.to_i
      return number if (1..MAX).cover?(number)

      fail ArgumentError, "'#{number_arg}' is not a valid year. Please use a number from 1 to #{MAX}."
    end

    def initialize(number_arg)
      self.class.check number_arg
      @bahai_era = number_arg.to_i
      calculate_number_vahid_and_kull_i_shay
      @months = {}
    end

    def to_s
      @bahai_era.to_s
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

    def add_month(month_number)
      if @months[month_number]
        @months[month_number]
      else
        @months[month_number] = Month.new(month_number)
      end
    end

    private

    def title_index
      @number - 1
    end

    def calculate_number_vahid_and_kull_i_shay
      @vahid, @number = (@bahai_era - 1).divmod(19)
      @kull_i_shay, @vahid = @vahid.divmod(19)
      @number += 1
      @vahid += 1
      @kull_i_shay += 1
    end
  end
end
