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
        subject:           "[#{newsletter_email.challenge&.challenge}] Your newsletter e-mail was declined",
        to:                newsletter_email.participant.email,
        template:          'AICrowd Declined Email Template',
        global_merge_vars: [
          {
            name:    'BODY',
            content: newsletter_email.decline_reason
          },
          {
            name:    'NAME',
            content: newsletter_email.participant.name
          },
          {
            name:    'CHALLENGE_NAME',
            content: newsletter_email.challenge&.challenge.to_s
          },
          {
            name:    'DECLINE_REASON',
            content: newsletter_email.decline_reason
          },
          {
            name:    'NEW_NEWSLETTER_EMAIL_URL',
            content: new_challenge_newsletter_emails_url(challenge_id: newsletter_email.challenge_id.to_i)
          }
        ]
      }
    end
  end
end
