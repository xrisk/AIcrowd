class Post < ApplicationRecord
  has_paper_trail
  include FriendlyId
  friendly_id :title, use: :slugged
  # has_many :likes, as: :reference, dependent: :destroy
  has_many :category_posts, dependent: :destroy
  has_many :categories, through: :category_posts
  has_many :votes, as: :votable

  belongs_to :participant
  belongs_to :challenge, optional: true
  belongs_to :submission, optional: true
  mount_uploader :thumbnail, RawImageUploader
  acts_as_commontable
  attr_accessor :notebook_file_path, :notebook_file, :category_names

  def vote(participant)
    self.votes.where(participant_id: participant.id).first if participant.present?
  end
end
