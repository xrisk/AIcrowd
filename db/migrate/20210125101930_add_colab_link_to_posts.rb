class AddColabLinkToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :colab_link, :text
  end
end
