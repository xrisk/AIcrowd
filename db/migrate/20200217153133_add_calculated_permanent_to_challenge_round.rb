class AddCalculatedPermanentToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :calcualated_permanent, :boolean, null: false, default: false
  end
end
