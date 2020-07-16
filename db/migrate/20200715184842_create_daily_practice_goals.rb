class CreateDailyPracticeGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_practice_goals do |t|
      t.string :title
      t.integer :points
      t.string :duration_text

      t.timestamps
    end
  end
end
