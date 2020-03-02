class CreateCategoryChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :category_challenges do |t|
      t.references :category
      t.references :challenge

      t.timestamps
    end
    add_index :category_challenges, [:category_id, :challenge_id], unique: true
  end
end
