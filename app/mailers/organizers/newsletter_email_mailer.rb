module Organizers
  class NewsletterEmailMailer < ApplicationMailer
    include SanitizationHelper

    def sendmail(newsletter_email_id)
      newsletter_email = NewsletterEmail.includes(:participant).find(newsletter_email_id)
      options          = format_options(newsletter_email)
      mandrill_send(options)
    end

    private

    def format_options(newsletter_email)
      options = {
        participant_id:    newsletter_email.participant_id,
        subject:           newsletter_email.subject,
        to:                newsletter_email.participant.email,
        cc:                newsletter_email.cc,
        bcc:               newsletter_email.bcc,
        template:          'AICrowd Newsletter Email Template',
        global_merge_vars: [
          {
            name:    'BODY',
            content: sanitize_html(newsletter_email.message)
          }
        ]
      }
    end
  end
end
