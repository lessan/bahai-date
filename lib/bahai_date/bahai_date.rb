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

end
