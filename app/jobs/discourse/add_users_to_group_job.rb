module Discourse
  class AddUsersToGroupJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id, participants_ids)
      challenge    = Challenge.find(challenge_id)
      participants = Participant.where(id: participants_ids)

      Discourse::AddUsersToGroupService.new(challenge: challenge, participants: participants).call
    end
  end
end
