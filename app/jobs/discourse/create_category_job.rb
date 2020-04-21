module Discourse
  class CreateCategoryJob < ApplicationJob
    queue_as :discourse

    def perform(challenge_id)
      challenge = Challenge.find(challenge_id)

      Discourse::CreateCategoryService.new(challenge: challenge).call
    end
  end
end
