module Discourse
  class RemoveUsersFromGroupJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id, usernames)
      challenge = Challenge.find(challenge_id)

      Discourse::RemoveUsersFromGroupService.new(challenge: challenge, usernames: usernames).call
    end
  end
end
