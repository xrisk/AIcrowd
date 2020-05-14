class ChangeNameNullToBadgeType < ActiveRecord::Migration[5.2]
  def change
    change_column_null :badge_types, :name, false
  end
end
