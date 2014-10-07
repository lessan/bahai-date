Gem::Specification.new do |s|
  s.name         = "bahai_date"
  s.version      = "1.0.0"
  s.author       = "Lessan Vaezi"
  s.email        = "lessan@gmail.com"
  s.homepage     = "https://github.com/lessan/bahai-date"
  s.summary      = "Gem to provide date conversion between the Gregorian calendar and the Baha'i calendar (also called the Badi calendar)"
  s.licenses     = ['Unlicense']

  s.files         = Dir["{bin,lib,spec}/**/*"] + %w(LICENSE.md README.md)
  s.test_files    = Dir["spec/**/*"]

  s.required_ruby_version = '>=2.0'
  s.add_development_dependency 'rspec', '~> 3'
end

