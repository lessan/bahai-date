Baha'i Date Ruby Gem
====================
A Ruby gem for conversion between the Gregorian calendar and the Baha'i (or Badi) calendar


Installation
------------
Add this line to your application's Gemfile:

`gem 'bahai_date'`

And then execute:

`$ bundle install`

Or, install it yourself:
`$ gem install bahai_date`

Example Usage
-----
```ruby
require "bahai_date"

today = BahaiDate.new(date: Date.today)
puts "to_s: " + today
puts "long_format: " + today.long_format
puts "to_gregorian: " + today.to_gregorian
```

License
-------
This is free and unencumbered software released into the public domain.

For more information, please refer to <http://unlicense.org/>

