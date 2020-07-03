class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.references :participant, foreign_key: true
      t.references :challenge_round, foreign_key: true
      t.integer :achieved_points

      t.timestamps
    end
  end
end
