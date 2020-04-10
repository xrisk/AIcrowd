# Be sure to restart your server when you modify this file.

if Rails.env.development?
  Rails.application.config.session_store :cookie_store, key: '_aicrowd_session'
else
  Rails.application.config.session_store :cookie_store, key: '_aicrowd_session', domain: ENV['DOMAIN_NAME'].gsub("https://www.", "").gsub("https://", "")
end
