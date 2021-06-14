class AddIsTiePossibleToCle < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_leaderboard_extras, :is_tie_possible, :boolean, default: true
  end
end
