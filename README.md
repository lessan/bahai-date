Baha'i Date Ruby Gem
====================
A Ruby gem for conversion between the Gregorian calendar and the Baha'i (or Badi) calendar.

You can learn more about this calendar on the [http://en.wikipedia.org/wiki/Bah%C3%A1'%C3%AD_calendar](Wikipedia entry).


Installation
------------
Add this line to your application's Gemfile:

`gem 'bahai_date'`

And then execute:

`$ bundle install`

Or, install it yourself:
`$ gem install bahai_date`


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

