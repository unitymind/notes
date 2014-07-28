$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../../app/*.rb', __FILE__)].each do |file|
  require file
end

Dir[File.expand_path('../../models/*.rb', __FILE__)].each do |file|
  require file
end