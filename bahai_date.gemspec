require_relative "lib/bahai_date/version"

Gem::Specification.new do |s|
  s.name = "bahai_date"
  s.version = BahaiDate::VERSION
  s.author = "Lessan Vaezi"
  s.email = "lessan@gmail.com"
  s.homepage = "https://github.com/lessan/bahai-date"
  s.summary = "Conversion between Gregorian and Baha'i (or Badi) calendars"
  s.description = "Provides functionality to convert between the Gregorian and Baha'i calendar, as well as significant dates and occasions in the Baha'i calendar such as the new year and holy days"
  s.licenses = ["Unlicense"]
  s.metadata = {
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/lessan/bahai-date",
    "changelog_uri" => "https://github.com/lessan/bahai-date/blob/master/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/lessan/bahai-date/issues"
  }

  s.files = Dir["{bin,lib,spec}/**/*"] + %w[CHANGELOG.md LICENSE.md README.md]

  s.required_ruby_version = ">= 3.3"
  s.add_dependency "bigdecimal", ">= 3.1"
  s.add_dependency "RubySunrise", "~> 0.3"
  s.add_development_dependency "irb", ">= 1.14"
  s.add_development_dependency "rake", ">= 13.0"
  s.add_development_dependency "rspec", "~> 3.13"
  s.add_development_dependency "simplecov", ">= 0.22"
  s.add_development_dependency "standard", ">= 1.57"
end
