class AddDefaultToBadgeTypeInBadges < ActiveRecord::Migration[5.2]
  def change
    change_column :aicrowd_badges, :badge_type_id, :integer, :default => 4, :null => false
  end
end
