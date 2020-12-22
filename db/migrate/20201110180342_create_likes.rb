class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :reference_id
      t.string :reference_type
      t.integer :participant_id

      t.timestamps
    end
  end
end
