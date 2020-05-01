class ChangeNameNullToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    change_column_null :aicrowd_badges, :name, false
  end
end
