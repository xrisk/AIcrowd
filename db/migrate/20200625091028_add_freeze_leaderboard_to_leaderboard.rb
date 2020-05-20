class AddFreezeLeaderboardToLeaderboard < ActiveRecord::Migration[5.2]
  def change
    add_column :base_leaderboards, :freeze_leaderboard, :boolean, default: false, null: false
    add_column :disentanglement_leaderboards, :freeze_leaderboard, :boolean, default: false, null: false
  end
end
