require 'mixpanel-ruby'

eu_consumer = Mixpanel::Consumer.new(
  'https://api-eu.mixpanel.com/track',
  'https://api-eu.mixpanel.com/engage',
  'https://api-eu.mixpanel.com/groups',
  )

::Tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN']) do |type, message|
  eu_consumer.send!(type, message)
end
if Rails.env.development?
  #silence local SSL errors
  Mixpanel.config_http do |http|
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end
