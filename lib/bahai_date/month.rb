module BahaiDate

  class Month 
    TITLES = %w[Baha Jalal Jamal Azamat Nur Rahmat Kalimat Kamal Asma Izzat Mashiyyat Ilm Qudrat Qawl Masail Sharaf Sultan Mulk Ala]
    TITLES_EN = %w[Splendour Glory Beauty Grandeur Light Mercy Words Perfection Names Might Will Knowledge Power Speech Questions Honour Sovereignty Dominion Loftiness]
    
    attr_reader :number, :title, :title_en

    def initialize(number_arg)
      validate number_arg
      @number = number_arg.to_i
      @title = TITLES[@number - 1]
      @title_en = TITLES_EN[@number - 1]
    end

  private

    def validate(number_arg)
      number = number_arg.to_i
      if (number < 1 || number > 19)
        raise ArgumentError, "'#{number}' is not a valid month. Please use 1 to 19."
      end
     end
  end

end
