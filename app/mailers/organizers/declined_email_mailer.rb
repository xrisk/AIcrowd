module Organizers
  class DeclinedEmailMailer < ApplicationMailer
    include SanitizationHelper

    def sendmail(newsletter_email)
      options = format_options(newsletter_email)
      mandrill_send(options)
    end

    private

    def format_options(newsletter_email)
      options = {
        participant_id:    newsletter_email.participant_id,
        subject:           "[#{newsletter_email.challenge.challenge}] Your e-mail was declined",
        to:                newsletter_email.participant.email,
        template:          'AICrowd Declined Email Template',
        global_merge_vars: [
          {
            name:    'BODY',
            content: newsletter_email.decline_reason
          }
        ]
      }
    end
  end
end
