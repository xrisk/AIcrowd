class StandardApplicationMailer < ActionMailer::Base
  default from: 'devops@aicrowd.com'
  layout 'mailer'
end
