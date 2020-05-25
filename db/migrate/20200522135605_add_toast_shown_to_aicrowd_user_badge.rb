class AddToastShownToAicrowdUserBadge < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_user_badges, :toast_shown, :boolean, null: false, default: false
  end
end
