ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'spec_helper'
require 'rspec/rails'

require 'support/config/capybara'
require 'support/config/database_cleaner'

require 'pundit/matchers'
require 'devise'

Dir[File.dirname(__FILE__) + "/support/helpers/*.rb"]
  .each { |f| require f }
Dir[File.dirname(__FILE__) + "/support/matchers/*.rb"]
  .each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::ControllerHelpers, type: :helper
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :feature
  config.include ControllerSpecHelpers, type: :controller
  config.include HeaderHelpers
  config.include FeatureSpecHelpers, type: :feature

  ## RSPEC RETRY
  # show retry status in spec process
  config.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true

  # run retry only on features
  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end

  # callback to be run between retries
  config.retry_callback = proc do |ex|
    # run some additional clean up task - can be filtered by example metadata
    if ex.metadata[:js]
      Capybara.reset!
    end
  end
  ## RSPEC RETRY END

  config.use_transactional_fixtures = false

  ### TODO: NATE: understand why this config block is necessary locally
  ### but not on build server.  Am I missing an environment variable?
  ### See discussion here: https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
  config.before(:each) do
    @request && @request.host = 'localhost'
  end

  # Fixes Timecop’s issue (https://goo.gl/1tujRj)
  #config.around(:each, freeze_time: true) do |example|
  #  Timecop.freeze(Time.zone.now.change(nsec: 0))
  #  example.run
  #  Timecop.return
  #end

  config.example_status_persistence_file_path = 'spec/examples.txt'
end
