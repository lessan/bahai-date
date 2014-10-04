module BahaiDate

  class Month 
    TITLES = %w[Baha Jalal Jamal Azamat Nur Rahmat Kalimat Kamal Asma Izzat Mashiyyat Ilm Qudrat Qawl Masail Sharaf Sultan Mulk Ala Ayyam-i-Ha]
    TITLES_HTML = %w[Bahá Jalál Jamál ‘Aẓamat Núr Raḥmat Kalimát Kamál Asmá’ ‘Izzat Ma<u>sh</u>íyyat ‘Ilm Qudrat Qawl Masá’il <u>Sh</u>araf Sulṭán Mulk ‘Alá’ Ayyám-i-Há]
    TITLES_EN = %w[Splendour Glory Beauty Grandeur Light Mercy Words Perfection Names Might Will Knowledge Power Speech Questions Honour Sovereignty Dominion Loftiness Ayyam-i-Ha]

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

  private

    def title_index
      if @number == -1
        19 #20th element of the array
      else
        @number - 1
      end
    end

    def validate(number_arg)
      number = number_arg.to_i
      if (number < -1 || number == 0 || number > 19 )
        raise ArgumentError, "'#{number}' is not a valid month. Please use 1 to 19 or -1 for Ayyam-i-Ha."
      end
     end

  end

end
