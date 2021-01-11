class CreateLockedSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :locked_submissions do |t|
      t.integer :challenge_id, null: false
      t.integer :submission_id, null: false
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
