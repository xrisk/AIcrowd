class StandardApplicationMailer < ActionMailer::Base
  default from: 'no-reply@aicrowd.com'
  layout 'mailer'
end
