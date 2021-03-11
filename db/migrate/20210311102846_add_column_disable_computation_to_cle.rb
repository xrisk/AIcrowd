class AddColumnDisableComputationToCle < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_leaderboard_extras, :disable_computation, :boolean, default: false
  end
end
