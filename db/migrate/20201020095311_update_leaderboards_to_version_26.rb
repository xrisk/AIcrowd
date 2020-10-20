class UpdateLeaderboardsToVersion26 < ActiveRecord::Migration[5.2]
  def change
    update_view :leaderboards, version: 26, revert_to_version: 25
  end
end
