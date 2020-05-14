class AddIndexToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    add_index :aicrowd_badges, :name, unique: true
  end
end
