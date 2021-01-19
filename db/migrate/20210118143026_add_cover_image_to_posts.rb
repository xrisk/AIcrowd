class AddCoverImageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :cover_image, :text
  end
end
