class AddMediaOnLeaderboardToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :media_on_leaderboard, :boolean
  end
end
