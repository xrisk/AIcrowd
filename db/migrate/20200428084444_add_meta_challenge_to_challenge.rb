class AddMetaChallengeToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :meta_challenge, :boolean
  end
end
