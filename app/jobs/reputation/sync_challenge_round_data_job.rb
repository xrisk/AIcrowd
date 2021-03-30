module Reputation
  class SyncChallengeRoundDataJob < ApplicationJob
    queue_as :default

    def perform(organizer_id, challenge_call_response_id)
      organizer               = Organizer.find(organizer_id)

      challenge_call_response = ChallengeCallResponse.find(challenge_call_response_id)

      organizer.participants.each do |participant|
        Admin::NotificationsMailer.challenge_call_response_email(participant, challenge_call_response).deliver_later
      end
    end
  end
end
