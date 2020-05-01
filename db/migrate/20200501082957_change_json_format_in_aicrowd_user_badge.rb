class ChangeJsonFormatInAicrowdUserBadge < ActiveRecord::Migration[5.2]
  def change
    change_column :aicrowd_user_badges, :custom_fields, :jsonb
  end
end
