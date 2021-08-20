class AddLevelToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_badges, :level, :integer
  end
end
