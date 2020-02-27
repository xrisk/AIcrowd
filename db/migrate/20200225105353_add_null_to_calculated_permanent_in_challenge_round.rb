class AddNullToCalculatedPermanentInChallengeRound < ActiveRecord::Migration[5.2]
  def change
    change_column_null :challenge_rounds, :calculated_permanent, false, false
  end
end
