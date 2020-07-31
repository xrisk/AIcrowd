class AddMlChallengeToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :ml_challenge, :boolean, default: false, null: false
  end
end
