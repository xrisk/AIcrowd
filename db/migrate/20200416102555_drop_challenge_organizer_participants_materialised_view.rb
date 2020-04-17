class DropChallengeOrganizerParticipantsMaterialisedView < ActiveRecord::Migration[5.2]
  def change
    drop_view :challenge_organizer_participants, materialized: true
  end
end
