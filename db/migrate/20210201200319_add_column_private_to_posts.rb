class AddColumnPrivateToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :private, :boolean, default: false
  end
end
