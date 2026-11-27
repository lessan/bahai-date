require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec standard]

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -I lib -r bahai_date"
end
