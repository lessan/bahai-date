create class: Day
    number
    title
    title_en

create class: Month
    number
    title
    title_en

create class: Year
    bahai_era
    number
    title
    title_en


update class BahaiDate to use the WeekDay, Day, Month, and Year classes
  gregorian_date
  weekday
  day
  month
  year
  vahid
  kull_i_shay

expose public methods on the BahaiDate class, and update README
  long_format
  to_gregorian


upload first version to rubygems

