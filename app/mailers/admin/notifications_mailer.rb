module Admin
  class NotificationsMailer < ApplicationMailer
    def challenge_call_response_email(participant, challenge_call_response)
      @participant             = participant
      @challenge_call_response = challenge_call_response
      @email_preferences_url   = EmailPreferencesTokenService.new(@participant).preferences_token_url
      subject                  = '[ADMIN:AIcrowd] Challenge Call response'

      mail(to: @participant.email, subject: subject)
    end

    def newsletter_email_notification_email(newsletter_email)
      @newsletter_email = newsletter_email
      @challenge        = newsletter_email.challenge
      @participant      = newsletter_email.participant
      subject           = "[#{@challenge&.challenge}] New newsletter email is waiting for verification"

      mail(to: first_admin.email, bcc: aicrowd_admins.pluck(:email), subject: subject)
    end

    def organizer_application_notification_email(participant, organizer_application)
      @participant           = participant
      @organizer_application = organizer_application
      @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url
      subject                = '[ADMIN:AIcrowd] Organizer Application Requested'

      mail(to: participant.email, subject: subject)
    end

    def submission_notification_email(participant, submission)
      @participant           = participant
      @submission            = submission
      @challenge             = @submission.challenge
      @email_preferences_url = EmailPreferencesTokenService.new(@participant).preferences_token_url
      subject                = "[ADMIN:AIcrowd/#{@challenge.challenge}] Submission made"

      mail(to: participant.email, subject: subject)
    end

    private

    def aicrowd_admins
      @aicrowd_admins ||= Participant.admins
    end

    def first_admin
      @first_admin ||= aicrowd_admins.first
    end
  end
end
