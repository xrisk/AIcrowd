ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'spec_helper'
require 'rspec/rails'

require 'support/config/capybara'
require 'support/config/factory_bot'
require 'support/config/database_cleaner'

require 'pundit/matchers'
require 'devise'

Dir[File.dirname(__FILE__) + "/support/helpers/*.rb"]
  .each { |f| require f }
Dir[File.dirname(__FILE__) + "/support/matchers/*.rb"]
  .each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::ControllerHelpers, type: :helper
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :feature
  config.include ControllerSpecHelpers, type: :controller
  config.include HeaderHelpers
  config.include FeatureSpecHelpers, type: :feature

  config.use_transactional_fixtures           = false
  config.example_status_persistence_file_path = 'spec/examples.txt'
end
