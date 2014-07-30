require 'sinatra/activerecord/rake'
require File.expand_path('../config/environment', __FILE__)

if %q(test development).include?(ENV['RACK_ENV'])
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end
