class FixColumnNameForAicrowdUserBadge < ActiveRecord::Migration[5.2]
  def change
    rename_column :aicrowd_user_badges, :aicrowd_badges_id, :aicrowd_badge_id
  end
end
