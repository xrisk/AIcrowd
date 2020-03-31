module Organizers
  class NewsletterEmailJob < ApplicationJob
    def perform(newsletter_email_id)
      newsletter_email = NewsletterEmail.includes(:participant).find(newsletter_email_id)

      Organizers::NewsletterEmailMailer.new.sendmail(newsletter_email)
    end
  end
end
