class ChangeDefaultValueForDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenge_leaderboard_extras, :default, false
  end
end
