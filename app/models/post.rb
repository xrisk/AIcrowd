class Post < ApplicationRecord
  has_paper_trail
  include FriendlyId
  friendly_id :title, use: :slugged
  has_many :likes, as: :reference, dependent: :destroy

  belongs_to :participant
  belongs_to :challenge, optional: true
  belongs_to :submission, optional: true
  mount_uploader :thumbnail, RawImageUploader
  acts_as_commontable
  attr_accessor :notebook_file_path



  def liked?(pariticipant)
    !!self.likes.find{|like| like.participant_id==participant.id}
  end
end
