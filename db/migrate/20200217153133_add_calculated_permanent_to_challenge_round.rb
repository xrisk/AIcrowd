class AddCalculatedPermanentToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :calcualated_permanent, :boolean
  end
end
