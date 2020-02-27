class AddDefaultValuetoCalculatedPermanentinChallengeRound < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenge_rounds, :calcualated_permanent, false
  end
end
