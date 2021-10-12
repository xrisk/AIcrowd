class AddColumnActiveToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_badges, :active, :boolean, default: true
  end
end
