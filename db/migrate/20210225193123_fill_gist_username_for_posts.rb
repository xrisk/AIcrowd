class FillGistUsernameForPosts < ActiveRecord::Migration[5.2]
  def change
    Post.update_all(gist_username: "sujnesh")
  end
end
