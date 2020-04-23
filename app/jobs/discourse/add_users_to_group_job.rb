module Discourse
  class AddUsersToGroupJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id, participants)
      challenge = Challenge.find(challenge_id)

      Discourse::AddUsersToGroupService.new(challenge: challenge, participants: participants).call
    end
  end
end
