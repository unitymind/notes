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
  config.include Notes::CapybaraHelpers, type: :feature

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction

    # Start transaction
    DatabaseCleaner.start

    # Run example
    example.run

    # Rollback transaction
    DatabaseCleaner.clean

    # Clear session data
    Capybara.reset_sessions!
  end
end

require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Capybara.configure do |config|
  config.app = Rack::URLMap.new({
    '/' => Notes::FrontendApp.new,
        '/api' => Notes::ApiApp.instance
  })
  config.server_port = 9293
end