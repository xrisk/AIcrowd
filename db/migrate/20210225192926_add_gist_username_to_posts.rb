class AddGistUsernameToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :gist_username, :string
  end
end
