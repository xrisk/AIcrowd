class AddSequenceToChallengeLeaderboardExtra < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_leaderboard_extras, :sequence, :integer, default: 0
  end
end
