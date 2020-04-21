module Discourse
  class UpdateCategoryJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id)
      challenge = Challenge.find(challenge_id)

      Discourse::UpdateCategoryService.new(challenge: challenge).call
    end
  end
end
