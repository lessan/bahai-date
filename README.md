Baha'i Date Ruby Gem
====================
A Ruby gem for conversion between the Gregorian calendar and the Baha'i (or Badi) calendar.

[![Gem Version](https://badge.fury.io/rb/bahai_date.png)](http://badge.fury.io/rb/bahai_date)


The Baha'i calendar
-------------------
In the Baha'i (or Badi) calendar there are 19 months each having 19 days, with 4 or 5 days left aside as intercalary days. Each weekday, day of the month and month of the year have a name, named after the attributes of God (such as Glory, Beauty, etc). The names have been transliterated into English from the original Arabic, and a translation is also provided.

Each year also has a name, as part of a 19 year cycle called a Vahid (meaning "unity"). Every 19 Vahids (i.e. 361 years) constitute a Kull-i-Shay (meaning "all things"). 

The year begins at Naw-Ruz, the day of the vernal equinox, on 20 or 21 March in this period. Year 1 began at Naw-Ruz 1844.

How the calendar works, how its dates are calculated, and how it was kept before 2015 are documented at
**https://lessan.github.io/bahai-date/**, with every year's dates from 1 to 1157 B.E. as JSON and CSV
(sources in `docs/`).


Calculations
------------
From 172 B.E. (2015), Naw-Ruz is the day on which the vernal equinox falls in
Tehran, counting days from sunset to sunset, and the Twin Holy Days are the
first and second days after the eighth new moon after Naw-Ruz, as the Universal
House of Justice set out in its message of 10 July 2014.

For 1-171 B.E. (21 March 1844 to 20 March 2015) the gem uses the fixed Western
arrangement printed at Shoghi Effendi's direction in *The Baha'i World*:
Naw-Ruz on 21 March, Ayyam-i-Ha from 26 February to 1 March (four or five days by
the Gregorian leap year), the Birth of the Bab on 20 October (5 'Ilm) and the
Birth of Baha'u'llah on 12 November (9 Qudrat). This is how Baha'is in the West
kept the calendar. Baha'is in Iran kept it differently: they took Naw-Ruz from
the moment of the equinox and kept the Twin Holy Days, the Declaration of the Bab
and the Martyrdom of the Bab on Islamic lunar dates. Before Western Baha'i
communities existed (before about 1910) the Western arrangement is applied
backwards. Dates before 172 B.E. are therefore a convention, not a record of what
was observed. Under it the Declaration and the Martyrdom of the Bab fall on
7 'Azamat and 16 Rahmat; from 172 B.E. they are 8 'Azamat and 17 Rahmat, the
dates 'Abdu'l-Baha gave. See https://lessan.github.io/bahai-date/history.html.

- The vernal equinox and new moons come from the algorithms in Jean Meeus,
  [*Astronomical Algorithms*](http://www.willbell.com/math/mc1.htm), in
  `lib/bahai_date/astro.rb`. They came from the *astro-algo* gem, which is
  unmaintained and no longer works on modern Ruby.
- Sunset comes from the US Naval Observatory's *Almanac for Computers*
  algorithm, in `lib/bahai_date/sunset.rb`. It came from the *RubySunrise* gem.

The gem has no runtime dependencies.

The specs check the gem against Table A of the official *Baha'i Dates 172 to 221
B.E.*, against the calendar bahai.org publishes (172-221 B.E.), and against the independent [badiDate](https://github.com/janrg/badiDate)
JavaScript library for every year it covers (172-507 B.E., to 2351). Why dates
stop at the Gregorian year 3000 is explained in `lib/bahai_date/logic.rb`.


Functionality
-------------
A BahaiDate instance can be created either from a Gregorian date or supplying the year, month and day in the Baha'i calendar.

A calendar can also be obtained using the YearCalendar class and providing a year. It is then populated with details about that year, each month and each day in it.


Limits
------
- Years 1 to 1157 B.E. are supported, which is Gregorian 21 March 1844 to
  March 3001. Past about 2351 the dates are the algorithms' best estimate:
  the Earth's rotation cannot be predicted precisely, and in some years the
  equinox falls within minutes of sunset in Tehran.
- A Baha'i day begins at sunset, but this gem converts whole Gregorian dates.
  `BahaiDate.new(date: Date.today)` gives the Baha'i date that begins at
  sunset on the evening before `Date.today`, so after sunset you need the next
  day's date. `Date.today` is also in the server's time zone, not the reader's.


Installation
------------
Requires Ruby 3.3 or newer; tested on 3.3, 3.4 and 4.0.

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
require 'bahai_date'

today = BahaiDate::BahaiDate.new(date: Date.today)

#or

nawruz = BahaiDate::BahaiDate.new(year: 171, month: 1, day: 1)
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
calendar = BahaiDate::YearCalendar.new(171)
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

