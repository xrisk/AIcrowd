module Challenges
  class NewsletterEmailsController < Challenges::BaseController
    def new
      @newsletter_email_form = NewsletterEmailForm.new
    end

    def create

    end
  end
end
