class AddBigChallengeCardImageToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :big_challenge_card_image, :boolean
  end
end
