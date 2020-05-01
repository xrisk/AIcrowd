class CreateAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :aicrowd_badges do |t|
      t.string :name
      t.text :description
      t.integer :badge_type_id
      t.timestamps
    end
  end
end
