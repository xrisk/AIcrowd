module Discourse
  class UpsertUserJob < ApplicationJob
    queue_as :discourse

    def perform(participant_id)
      participant = Participant.find(participant_id)

      Discourse::UpsertUserService.new(participant: participant).call
    end
  end
end
