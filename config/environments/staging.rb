Rails.application.configure do
  is_review_app      = ENV['IS_REVIEW_APP'] == 'true'
  # Handle dynamic domain names of review_apps
  ENV['DOMAIN_NAME'] = "https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com" if is_review_app

  config.cache_classes                             = true
  config.eager_load                                = true
  config.consider_all_requests_local               = true
  config.action_controller.perform_caching         = true
  config.public_file_server.enabled                = true
  config.assets.js_compressor                      = Uglifier.new(harmony: true)
  config.assets.css_compressor                     = :sass
  config.assets.compile                            = true
  config.assets.digest                             = true
  config.force_ssl                                 = true
  config.log_level                                 = :debug
  config.log_tags                                  = [:request_id]
  config.i18n.fallbacks                            = true
  config.log_formatter                             = ::Logger::Formatter.new
  config.action_mailer.perform_caching             = false
  config.active_support.deprecation                = :notify
  config.active_storage.service                    = :local
  config.action_mailer.default_url_options         = { host: ENV['DOMAIN_NAME'] }
  config.action_controller.asset_host              = if is_review_app # Fetch assets from web server for review apps
                                                       ENV['DOMAIN_NAME']
                                                     else # Fetch assets from Cloudfront for staging
                                                       "https://#{ENV['CLOUDFRONT_ASSETS_DOMAIN']}"
                                        end

  config.active_record.dump_schema_after_migration = false

  config.cache_store = :mem_cache_store,
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
