module Gitlab
  class UpdateUsernameJob < ApplicationJob
    queue_as :gitlab

    def perform(participant_id)
      participant = Participant.find(participant_id)

      Gitlab::UpdateUsernameService.new(participant: participant).call
    end
  end
end
