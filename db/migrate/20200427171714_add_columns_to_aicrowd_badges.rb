class AddColumnsToAicrowdBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :aicrowd_badges, :code, :text
    add_reference :aicrowd_badges, :badges_event, foreign_key: true
  end
end
