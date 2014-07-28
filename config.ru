require 'rubygems'
require 'bundler'
Bundler.require
require './api/notes'
require './models/note'
require './app'

run Rack::Cascade.new [Notes::Application, Notes::API::Notes]
