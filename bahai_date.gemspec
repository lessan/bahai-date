lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bahai_date/version"

Gem::Specification.new do |s|
  s.name = "bahai_date"
  s.version = BahaiDate::VERSION
  s.author = "Lessan Vaezi"
  s.email = "lessan@gmail.com"
  s.homepage = "https://github.com/lessan/bahai-date"
  s.summary = "Conversion between Gregorian and Baha'i (or Badi) calendars"
  s.description = "Provides functionality to convert between the Gregorian and Baha'i calendar, as well as significant dates and occasions in the Baha'i calendar such as the new year and holy days"
  s.licenses = ["Unlicense"]

  s.files = Dir["{bin,lib,spec}/**/*"] + %w[LICENSE.md README.md]

  s.required_ruby_version = ">=2.0"
  s.add_runtime_dependency "tzinfo", "~> 1.2"
  s.add_runtime_dependency "RubySunrise", "~> 0.3"
  s.add_runtime_dependency "astro-algo", "~> 0"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "simplecov", "~> 0"
end
