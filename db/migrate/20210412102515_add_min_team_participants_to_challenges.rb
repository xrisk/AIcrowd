class AddMinTeamParticipantsToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :min_team_participants, :integer, default: 1
  end
end
