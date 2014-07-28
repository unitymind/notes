require 'rubygems'
require 'bundler'

Bundler.require

require './api/notes'
require './models/note'
require './app'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

ActiveSupport::JSON::Encoding.use_standard_json_time_format = false

run Rack::Cascade.new [Notes::Application, Notes::API::Notes]
