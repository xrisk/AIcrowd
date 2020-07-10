class ChangeBaseLeaderboardBaselineDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :base_leaderboards, :baseline, from: nil, to: false
  end
end
