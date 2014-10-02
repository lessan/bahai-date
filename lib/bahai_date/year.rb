module BahaiDate

  class Year 
    TITLES = %w[Alif Ba Ab Dal Bab Vav Abad Jad Baha Hubb Bahhaj Javab Ahad Vahhab Vidad Badi Bahi Abha Vahid]
    TITLES_EN = %w[A B Father D Gate V Eternity Generosity Splendour Love Delightful Answer Single Bountiful Affection Beginning Luminous Most Luminous Unity]
    
    attr_reader :bahai_era, :number, :title, :title_en, :vahid, :kull_i_shay

    def initialize(number_arg)
      validate number_arg
      @bahai_era = number_arg.to_i
      calculate_number_vahid_and_kull_i_shay
      @title = TITLES[@number - 1]
      @title_en = TITLES_EN[@number - 1]
    end

  private

    def validate(number_arg)
      number = number_arg.to_i
      if (number < 1)
        raise ArgumentError, "'#{number}' is not a valid year. Please use a number greater than or equal to 1."
      end
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
