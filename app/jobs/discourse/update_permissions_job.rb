module Discourse
  class UpdatePermissionsJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id)
      challenge = Challenge.find(challenge_id)

      Discourse::UpdateCategoryService.new(challenge: challenge).call

      if challenge.hidden_in_discourse?
        Discourse::AddUsersToGroupService.new(challenge: challenge, participants: challenge.participants_and_organizers).call
      end
    end
  end
end
