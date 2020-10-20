class UpdateOngoingLeaderboardsToVersion10 < ActiveRecord::Migration[5.2]
  def change
    update_view :ongoing_leaderboards, version: 10, revert_to_version: 9
  end
end
