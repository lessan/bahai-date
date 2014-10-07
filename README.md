Baha'i Date Ruby Gem
====================
A Ruby gem for conversion between the Gregorian calendar and the Baha'i (or Badi) calendar.


The Baha'i calendar
-------------------
In the Baha'i (or Badi) calendar there are 19 months each having 19 days, with 4 or 5 days left aside as intercalery days. Each weekday, day of the month and month of the year have a name, named after the attributes of God (such as Glory, Beauty, etc). The names have been transliterated into English from the original Arabic, and a translation is also provided.

Each year also has a name, as part of a 19 year cycle called a Vahid (meaning "unity"). Every 19 Vahids (i.e. 361 years) constitute a Kull-i-Shay (meaning "all things"). 

The calendar begins on the vernal equinox, normally on the 20th or 21st of March. The first year is 1844.

More information about this calendar is on the [Wikipedia entry](http://en.wikipedia.org/wiki/Bah%C3%A1'%C3%AD_calendar).


Functionality
-------------
A BahaiDate instance can be created either from a Gregorian date or supplying the year, month and day in the Baha'i calendar.

The instance then exposes:
- **weekday**
 - **number**: e.g. 6
 - **title**: e.g. Istijlal
 - **translation**: e.g. Majesty
 - **html**: e.g. Istijlál
 - **english_equivalent**: e.g. Thursday
- **day**
 - **number**: e.g. 1
 - **title**: e.g. Baha
 - **translation**: e.g. Splendour
 - **html**: e.g. Bahá
- **month**
 - **number**: e.g. 1
 - **title**: e.g. Baha
 - **translation**: e.g. Splendour
 - **html**: e.g. Bahá
- **year**
 - **bahai_era**: e.g. 172
 - **number**: e.g. 1
 - **title**: e.g. Alif
 - **translation**: e.g. A
 - **html**: e.g. Alif
 - **vahid**: e.g. 10
 - **kull_i_shay**: e.g. 1
- **gregorian_date**: e.g. 2015-3-21 (using the ruby Date class)
- **occasions**: array of Occasion objects:
 - **type**: e.g. holy
 - **work_suspended?**: e.g. true
 - **title**: e.g. Naw-Ruz (New Year)
 - **short_title**: e.g. Naw-Ruz
 - **title_html**: e.g. Naw-Rúz (New Year)
 - **short_title_html**: e.g. Naw-Rúz


Installation
------------
Add this line to your application's Gemfile:

`gem 'bahai_date'`

And then execute:

`$ bundle install`

Or, install it yourself:
`$ gem install bahai_date`


Example Usage
-------------
```ruby
require "bahai_date"

today = BahaiDate.new(date: Date.today)
puts "to_s: " + today.to_s
puts "long_format: " + today.long_format
puts "gregorian_date: " + today.gregorian_date.to_s
```
Outputs:
```
to_s: 171.11.8
long_format: Jalal 8 Mashiyyat 171 B.E.
gregorian_date: 2014-10-04
```


License
-------
This is free and unencumbered software released into the public domain.

For more information, please refer to <http://unlicense.org/>

