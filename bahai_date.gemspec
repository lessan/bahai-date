lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bahai_date/version'

Gem::Specification.new do |s|
  s.name         = 'bahai_date'
  s.version      = BahaiDate::VERSION
  s.author       = 'Lessan Vaezi'
  s.email        = 'lessan@gmail.com'
  s.homepage     = 'https://github.com/lessan/bahai-date'
  s.summary      = "Gem to provide date conversion between the Gregorian calendar and the Baha'i (or Badi) calendar"
  s.licenses     = ['Unlicense']

  s.files        = Dir['{bin,lib,spec}/**/*'] + %w(LICENSE.md README.md)
  s.test_files   = Dir['spec/**/*']

  s.required_ruby_version = '>=2.0'
  s.add_runtime_dependency 'tzinfo'
  s.add_runtime_dependency 'RubySunrise'
  s.add_runtime_dependency 'astro-algo'
  s.add_development_dependency 'rspec', '~> 3'
end
