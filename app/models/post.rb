class Post < ApplicationRecord
  has_many :likes, as: :reference, dependent: :destroy
  belongs_to :challenge, optional: true
  belongs_to :submission, optional: true
  mount_uploader :thumbnail, RawImageUploader
  acts_as_commontable


  def liked?(pariticipant)
    !!self.likes.find{|like| like.participant_id==participant.id}
  end
end
