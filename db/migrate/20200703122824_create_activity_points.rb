class CreateActivityPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_points do |t|
      t.string :activity_key, null: false
      t.string :description
      t.integer :point, null: false

      t.timestamps
    end
  end
end
