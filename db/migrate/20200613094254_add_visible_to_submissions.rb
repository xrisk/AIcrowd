class AddVisibleToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :visible, :boolean, default: true, null: false
  end
end
