module Organizers
  class PreviewNewsletterEmailJob < ApplicationJob
    def perform(newsletter_email)
      Organizers::NewsletterEmailMailer.new.sendmail(newsletter_email)
    end
  end
end
