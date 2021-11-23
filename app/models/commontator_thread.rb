class CommontatorThread < ApplicationRecord
  def post_user
    return nil if !self.commontable_type == "Post"
    post = Post.find(self.commontable_id)
    return post.participant
  end
end