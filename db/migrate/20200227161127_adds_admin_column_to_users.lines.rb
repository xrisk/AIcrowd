# This migration comes from lines (originally 20200201143652)

class AddsAdminColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :lines_users, :admin, :boolean, default: false, null: false
  end
end