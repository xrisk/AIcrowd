module Discourse
  class CreateCategoryJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id)
      challenge = Challenge.find(challenge_id)

      if challenge.hidden_in_discourse?
        Discourse::CreateGroupService.new(challenge: challenge).call
        Discourse::AddUsersToGroupService.new(challenge: challenge, participants: challenge.participants_and_organizers).call
      end

      Discourse::CreateCategoryService.new(challenge: challenge).call
    end
  end
end
