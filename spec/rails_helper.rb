ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

require 'spec_helper'
require 'rspec/rails'

require 'support/config/capybara'
require 'support/config/factory_bot'
require 'support/config/warden'
require 'support/config/vcr'

# Load Error classes from ApiClient classes
require "#{Rails.root}/app/services/discourse/api_client.rb"
require "#{Rails.root}/app/services/gitlab/api_client.rb"

require 'pundit/matchers'

Dir[File.dirname(__FILE__) + '/support/helpers/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/support/matchers/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/support/shared_examples/*.rb'].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before(:each) do
    next if self.class.metadata[:requests_allowed]

    Discourse::FetchLatestTopicsService.any_instance.stub(:call).and_return(BaseService::Result.new(true, []))
    Discourse::FetchUserPostsService.any_instance.stub(:call).and_return(BaseService::Result.new(true, []))
    Discourse::FetchTopContributorsService.any_instance.stub(:call).and_return(BaseService::Result.new(true, []))
    Discourse::FetchBaselineTagService.any_instance.stub(:call).and_return(BaseService::Result.new(true, []))
    Discourse::FetchSearchResultsService.any_instance.stub(:call).and_return(BaseService::Result.new(true, []))
  end

  config.infer_spec_type_from_file_location!

  config.include HeaderHelpers
  config.include FeatureSpecHelpers, type: :feature

  config.use_transactional_fixtures           = true
  config.example_status_persistence_file_path = 'spec/examples.txt'

  ActiveJob::Base.queue_adapter = :test
end
