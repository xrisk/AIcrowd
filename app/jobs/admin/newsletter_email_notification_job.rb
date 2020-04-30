module Admin
  class NewsletterEmailNotificationJob < ApplicationJob
    def perform(newsletter_email_id)
      newsletter_email = NewsletterEmail.find(newsletter_email_id)

      Admin::NewsletterEmailNotificationMailer.new.sendmail(newsletter_email)
    end
  end
end
