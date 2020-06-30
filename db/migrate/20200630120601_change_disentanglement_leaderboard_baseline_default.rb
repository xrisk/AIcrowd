class ChangeDisentanglementLeaderboardBaselineDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :disentanglement_leaderboards, :baseline, from: nil, to: false
  end
end
