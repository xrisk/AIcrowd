class RemoveDisentaglementLeaderboardsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :disentanglement_leaderboards
  end
end
