class AddFreezeColumnToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :freeze_flag, :boolean, null: false, default: false
    add_column :challenge_rounds, :freeze_duration, :integer
  end
end
