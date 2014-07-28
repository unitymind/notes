require File.expand_path('../config/environment', __FILE__)
require File.expand_path('../app', __FILE__)

ActiveSupport::JSON::Encoding.use_standard_json_time_format = false

run Notes::App.instance
