module Admin
  class NewsletterEmailNotificationMailer < ApplicationMailer
    def sendmail(newsletter_email)
      options = format_options(newsletter_email)
      mandrill_send(options)
    end

    private

    def format_options(newsletter_email)
      options = {
        participant_id:    first_admin.id,
        subject:           "[#{newsletter_email.challenge&.challenge}] New newsletter email is waiting for verification",
        to:                first_admin.email,
        bcc:               aicrowd_admins.pluck(:email),
        template:          'AICrowd Newsletter Email Notification Template',
        global_merge_vars: [
          {
            name:    'CHALLENGE_NAME',
            content: newsletter_email.challenge&.challenge.to_s
          },
          {
            name:    'CHALLENGE_URL',
            content: challenge_url(id: newsletter_email&.challenge&.id.to_i)
          },
          {
            name:    'NEWSLETTER_EMAIL_ADMIN_URL',
            content: admin_newsletter_email_url(newsletter_email)
          }
        ]
      }
    end

    def aicrowd_admins
      @aicrowd_admins ||= Participant.admins
    end

    def first_admin
      @first_admin ||= aicrowd_admins.first
    end
  end
end
