
module Organizers
  class NotificationsMailer < StandardApplicationMailer
    def eua_notification_email(organizer_participant, clef_task, participant)
      @organizer_participant = organizer_participant
      @clef_task             = clef_task
      @participant           = participant
      @challenge             = clef_task.challenges.first
      @email_preferences_url = EmailPreferencesTokenService.new(@organizer_participant).preferences_token_url
      subject                = "[ImageCLEF AICrowd] - New EUA uploaded for #{@clef_task.task}"

      mail(to: @organizer_participant.email, subject: subject)
    end
  end
end
