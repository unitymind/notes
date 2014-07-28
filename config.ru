require 'rubygems'
require 'bundler'
Bundler.require
require './app'

run Rack::Cascade.new [Notes::Application, Notes::API::Notes]
