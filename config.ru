require File.expand_path('../config/environment', __FILE__)

run Rack::URLMap.new({
  '/' => Notes::FrontendApp.new,
  '/api' => Notes::ApiApp.instance
})
