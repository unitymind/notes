$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app/models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

require 'sinatra/activerecord'

Dir[File.expand_path('../../app/*.rb', __FILE__)].each do |file|
  require file
end

Dir[File.expand_path('../../app/models/*.rb', __FILE__)].each do |file|
  require file
end

ActiveSupport::JSON::Encoding.use_standard_json_time_format = false