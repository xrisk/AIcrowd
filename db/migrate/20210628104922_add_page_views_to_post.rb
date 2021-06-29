class AddPageViewsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :page_views, :integer, default: 0
  end
end
