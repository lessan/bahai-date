Baha'i Date Ruby Gem
====================
A Ruby gem for conversion between the Gregorian calendar and the Baha'i (or Badi) calendar.

[![Gem Version](https://badge.fury.io/rb/bahai_date.png)](http://badge.fury.io/rb/bahai_date)


The Baha'i calendar
-------------------
In the Baha'i (or Badi) calendar there are 19 months each having 19 days, with 4 or 5 days left aside as intercalery days. Each weekday, day of the month and month of the year have a name, named after the attributes of God (such as Glory, Beauty, etc). The names have been transliterated into English from the original Arabic, and a translation is also provided.

Each year also has a name, as part of a 19 year cycle called a Vahid (meaning "unity"). Every 19 Vahids (i.e. 361 years) constitute a Kull-i-Shay (meaning "all things"). 

The calendar begins on the vernal equinox, normally on the 20th or 21st of March. The first year is 1844.

More information about this calendar is on the [Wikipedia entry](http://en.wikipedia.org/wiki/Bah%C3%A1'%C3%AD_calendar).


Calculations
------------
The source of the algorithms used to determine the vernal equinox and lunar
phases is the book [*Astronomical Algorithms*](http://www.willbell.com/math/mc1.htm) by Jean Meeus, which has become an authority on this subject in computer science circles (for example, [NASA uses it](http://eclipse.gsfc.nasa.gov/phase/phasecat.html)).

Some of the algorithms in the book have been implemented in the following ruby
gem, which we use here:
https://rubygems.org/gems/astro-algo

The following ruby gem is widely used to determine the time for sunset at a given location, and we use it here:
https://rubygems.org/gems/RubySunrise


Functionality
-------------
A BahaiDate instance can be created either from a Gregorian date or supplying the year, month and day in the Baha'i calendar.

A calendar can also be obtained using the YearCalendar class and providing a year. It is then populated with details about that year, each month and each day in it.


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
Creating an instance:
```ruby
require "bahai_date"

today = BahaiDate.new(date: Date.today)

#or

nawruz = BahaiDate.new(year: 171, month: 1, day: 1)
```

Attributes:
```ruby
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

Calendar:
```ruby
calendar = YearCalendar.new(171)
puts "Year: " + calendar.bahai_era.to_s
puts "Month 1:" + calendar.months[1].title
puts "  Day 1 in Month 1:" + calendar.months[1].days[1].title
puts "         (weekday):" + calendar.months[1].days[1].weekday.title
puts "       (occasions):" + calendar.months[1].days[1].occasions[0].title
puts "                   " + calendar.months[1].days[1].occasions[1].title
```
Outputs:
```
Year: 171
Month 1:Baha
  Day 1 in Month 1:Baha
         (weekday):Istiqlal
       (occasions):Naw-Ruz (New Year)
                   Nineteen Day Feast of the month of Baha (Splendour)
```


License
-------
This is free and unencumbered software released into the public domain.

For more information, please refer to <http://unlicense.org/>

