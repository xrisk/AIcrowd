class AddReputationColumnsToCle < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_leaderboard_extras, :weight, :float, default: 0.005
    add_column :challenge_leaderboard_extras, :sub_round_size, :integer, default: 1
  end
end
