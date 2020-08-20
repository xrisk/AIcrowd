class AddShowLeaderboardToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :show_leaderboard, :boolean
  end
end
