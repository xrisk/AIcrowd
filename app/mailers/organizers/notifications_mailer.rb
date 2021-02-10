module Organizers
  class NotificationsMailer < ApplicationMailer

    def eua_notification_email(organizer_participant, clef_task, participant)
      @organizer_participant   = organizer_participant
      @clef_task               = clef_task
      @participant             = participant
      @challenge               = clef_task.challenges.first
      @email_preferences_url   = EmailPreferencesTokenService.new(@organizer_participant).preferences_token_url
      subject                  = "[#{@challenge&.challenge}] - New EUA uploaded for #{@clef_task.task}"
      @meta_challenge_id       = ChallengeProblems.where(problem: @challenge, exclusive: true)&.first&.challenge&.slug
      @clef_task_challenge_url = get_clef_task_challenge_url

      mail(to: @organizer_participant.email, subject: subject)
    end

    def received_application_email(organizer_application)
      @organizer_application = organizer_application
      subject                = "[AIcrowd] Organizer Application Received"

      mail(to: @organizer_application.email, subject: subject)
    end

    def get_clef_task_challenge_url
      link = clef_task_challenge_url(@challenge)
      if @meta_challenge_id.present?
        return link.gsub!("#{@challenge.slug}/clef_task", "#{@meta_challenge_id}/problems/#{@challenge.slug}/clef_task")
      end
      return link
    end

  end
end
