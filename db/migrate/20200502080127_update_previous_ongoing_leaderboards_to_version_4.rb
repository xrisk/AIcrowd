class UpdatePreviousOngoingLeaderboardsToVersion4 < ActiveRecord::Migration[5.2]
  def change
    update_view :previous_ongoing_leaderboards, version: 4, revert_to_version: 3
  end
end
