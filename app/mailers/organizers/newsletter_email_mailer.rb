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
        cc:                allowed_emails(newsletter_email, :cc),
        bcc:               allowed_emails(newsletter_email, :bcc),
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

    def allowed_emails(newsletter_email, attribute)
      newsletter_emails   = newsletter_email.public_send(attribute).split(',').map(&:strip)
      existing_emails     = Participant.where(email: newsletter_emails).pluck(:email)
      not_existing_emails = newsletter_emails - existing_emails
      allowed_emails      = Participant.where(email: existing_emails, agreed_to_organizers_newsletter: true).pluck(:email)

      (not_existing_emails + allowed_emails).join(',')
    end
  end
end
