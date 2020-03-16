class AddAcknowledgedToChallengeCall < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_calls, :acknowledged, :boolean, default: false, null: false
  end
end
