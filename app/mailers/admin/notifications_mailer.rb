module Admin
  class NotificationsMailer < StandardApplicationMailer
    def challenge_call_response_email(participant, challenge_call_response)
      @participant             = participant
      @challenge_call_response = challenge_call_response
      @email_preferences_url   = EmailPreferencesTokenService.new(@participant).preferences_token_url

      subject = "[ADMIN:AIcrowd] Challenge Call response"

      mail(to: @participant.email, subject: subject)
    end
  end
end
