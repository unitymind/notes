if ENV['RACK_ENV'] != 'production'
  require 'sinatra/activerecord/rake'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
else
  load 'active_record/railties/databases.rake'
end
