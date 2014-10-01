Gem::Specification.new do |s|
  s.name         = "bahai_date"
  s.version      = "0.1.0"
  s.author       = "Lessan Vaezi"
  s.email        = "lessan@gmail.com"
  s.homepage     = "http://bahaidate.today"
  s.summary      = "Gem to provide date conversion between the Gregorian calendar and the Baha'i calendar (also called the Badi calendar)"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.licenses     = ['Unlicense']

  s.files         = Dir["{bin,lib,spec}/**/*"] + %w(LICENSE.md README.md)
  s.test_files    = Dir["spec/**/*"]

  s.required_ruby_version = '>=2.0'
  s.add_development_dependency 'rspec', '~> 3'
end

