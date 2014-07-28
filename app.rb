require 'sinatra/base'
require 'sinatra/activerecord'

module Notes
  class Application < Sinatra::Base
    register Sinatra::ActiveRecordExtension
  end
end
