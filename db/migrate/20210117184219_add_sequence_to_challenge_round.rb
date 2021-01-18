class AddSequenceToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :sequence, :integer, default: 0
  end
end
