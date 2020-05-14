class ChangeNameNullToBadgesEvent < ActiveRecord::Migration[5.2]
  def change
    change_column_null :badges_events, :name, false
  end
end
