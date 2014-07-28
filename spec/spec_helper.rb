ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rack/test'
require 'factory_girl'
require 'faker'
require 'database_cleaner'
require 'logger'

RACK_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(RACK_ROOT, 'spec/support/**/*.rb')].each {|f| require f }
Dir[File.join(RACK_ROOT, 'spec/factories/**/*.rb')].each {|f| require f }

ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Base.logger = Logger.new(File.new(File.expand_path("../../log/#{ENV['RACK_ENV']}.log", __FILE__),'a+'))

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end