class UpdateParticipantChallengesViewToVersion8 < ActiveRecord::Migration[5.2]
  def change
    drop_view :participant_challenges
    create_view :participant_challenges, version: 8
  end
end
