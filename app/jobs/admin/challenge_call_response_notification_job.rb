class Admin::ChallengeCallResponseNotificationJob < ApplicationJob
  def perform(challenge_call_response)
    participant_ids = challenge_call_response.challenge_call&.organizer&.participants&.ids
    if participant_ids.present?
      participant_ids.each do |participant_id|
        Admin::ChallengeCallResponseNotificationMailer.new
            .sendmail(participant_id, challenge_call_response)
      end
    end
  end
end
