require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir                    = 'spec/vcr'
  config.ignore_localhost                        = true
  config.ignore_hosts 'chromedriver.storage.googleapis.com'
  config.default_cassette_options                = { record: :new_episodes }

  config.configure_rspec_metadata!
  config.hook_into(:webmock)

  config.filter_sensitive_data('REDACTED') { ENV['DISCOURSE_API_USERNAME'] }
  config.filter_sensitive_data('REDACTED') { ENV['DISCOURSE_API_KEY'] }
  config.filter_sensitive_data('REDACTED') { ENV['EVALUATIONS_API_KEY'] }
  config.filter_sensitive_data('REDACTED') { ENV['EVALUATIONS_API_HOST'] }
  config.filter_sensitive_data('REDACTED') { ENV['GITLAB_API_KEY'] }
end
