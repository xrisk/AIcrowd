class CreateUserRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ratings do |t|
      t.references :participant, foreign_key: true
      t.float :rating
      t.float :temporary_rating
      t.float :variation
      t.float :temporary_variation
      t.references :challenge_round, foreign_key: true
      t.timestamps
    end
  end
end
