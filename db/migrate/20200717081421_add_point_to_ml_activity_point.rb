class AddPointToMlActivityPoint < ActiveRecord::Migration[5.2]
  def change
    add_column :ml_activity_points, :point, :integer, default: 0, null: false
  end
end
