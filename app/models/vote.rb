class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :participant, optional: true

  def post_user
    if self.votable_type == "Post"
      return self.votable.participant
    end
  end
end
