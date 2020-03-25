module Organizers
  class NewsletterEmailJob < ApplicationJob
    def perform(newsletter_email_id)
      Organizers::NewsletterEmailMailer.new.sendmail(newsletter_email_id)
    end
  end
end
