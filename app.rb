require 'sinatra/base'
require 'sinatra/activerecord'
require './api/notes'
require './models/note'

module Notes
  class Application < Sinatra::Base
    register Sinatra::ActiveRecordExtension
  end
end
