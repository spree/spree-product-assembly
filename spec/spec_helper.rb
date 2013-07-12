ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'ffaker'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/authorization_helpers'

RSpec.configure do |config|
  config.color = true
  config.mock_with :rspec
  config.use_transactional_fixtures = true

  config.include FactoryGirl::Syntax::Methods

  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :feature
end
