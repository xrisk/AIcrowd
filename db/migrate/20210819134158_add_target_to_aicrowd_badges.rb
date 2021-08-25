class AddTargetToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_badges, :target, :integer
  end
end
