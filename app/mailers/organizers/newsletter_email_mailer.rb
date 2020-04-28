module Organizers
  class NewsletterEmailMailer < ApplicationMailer
    include SanitizationHelper

    def sendmail(newsletter_email)
      options = format_options(newsletter_email)
      mandrill_send(options)
    end

    private

    def format_options(newsletter_email)
      options = {
        participant_id:    newsletter_email.participant_id,
        subject:           "[#{newsletter_email.challenge&.challenge}] #{newsletter_email.subject}",
        to:                newsletter_email.participant.email,
        cc:                newsletter_email.cc,
        bcc:               newsletter_email.bcc,
        template:          'AICrowd Newsletter Email Template',
        global_merge_vars: [
          {
            name:    'BODY',
            content: sanitize_html(newsletter_email.message)
          },
          {
            name:    'CHALLENGE_NAME',
            content: newsletter_email.challenge&.challenge.to_s
          },
          {
            name:    'CHALLENGE_URL',
            content: challenge_url(id: newsletter_email&.challenge&.id.to_i)
          },
          {
            name:    'EMAIL_PREFERENCES_URL',
            content: edit_participant_registration_url
          }
        ]
      }
    end
  end
end
