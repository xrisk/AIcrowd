class RenameColumnInChallengeRound < ActiveRecord::Migration[5.2]
  def change
    rename_column :challenge_rounds, :calcualated_permanent, :calculated_permanent
  end
end
