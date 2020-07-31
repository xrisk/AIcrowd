Rails.application.configure do
  config.cache_classes                     = true
  config.eager_load                        = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.read_encrypted_secrets            = false
  config.public_file_server.enabled        = true
  config.assets.js_compressor              = Uglifier.new(harmony: true)
  config.assets.css_compressor             = :sass
  config.assets.compile                    = true
  config.force_ssl                         = true
  config.log_level                         = :warn
  config.log_tags                          = [:request_id]
  config.i18n.fallbacks                    = true
  config.log_formatter                     = ::Logger::Formatter.new

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "crowdai_#{Rails.env}"
  config.action_mailer.perform_caching = false
  config.active_support.deprecation    = :notify

  config.active_storage.service = :local

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
  config.action_mailer.default_url_options = { host: ENV['DOMAIN_NAME'] }
  config.action_controller.asset_host      = "https://#{ENV['CLOUDFRONT_ASSETS_DOMAIN']}"

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.smtp_settings       = {
    address:              ENV['SMTP_ADDRESS'],
    authentication:       :plain,
    domain:               ENV['SMTP_DOMAIN'],
    enable_starttls_auto: true,
    password:             ENV['SMTP_PASSWORD'],
    port:                 '587',
    user_name:            ENV['SMTP_USERNAME']
  }
  config.action_mailer.default_url_options = { host: ENV['SMTP_DOMAIN'] }
  config.cache_store                       = :mem_cache_store,
                                             ENV['MEMCACHEDCLOUD_SERVERS'].to_s.split(','),
                                             {
                                               username:             ENV['MEMCACHEDCLOUD_USERNAME'],
                                               password:             ENV['MEMCACHEDCLOUD_PASSWORD'],
                                               failover:             true,
                                               socket_timeout:       1.5,
                                               socket_failure_delay: 0.2,
                                               down_retry_delay:     60
                                             }
end
Rails.application.routes.default_url_options[:host] = ENV['DOMAIN_NAME']
