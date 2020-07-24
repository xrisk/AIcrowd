class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.text :message, null: false
      t.references :participant, foreign_key: true

      t.timestamps
    end
  end
end
