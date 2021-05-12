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

  validate :submission_notebook_already_created?

  default_scope { order('created_at DESC') }
  scope :is_public, -> { where(private: false) }

  COLAB_URL = ENV['COLAB_URL']
  GIST_URL = ENV['GIST_URL']
  USER_NAME = ENV['GIST_USERNAME']

  def vote(participant)
    self.votes.where(participant_id: participant.id).first if participant.present?
  end

  def get_random_thumbnail
    images = ["post-img-1.jpg", "post-img-2.jpg"]
    img = images.sample
    upload_image_file = ActionDispatch::Http::UploadedFile.new({
      filename: img,
      type: "image/jpg",
      tempfile: File.new(Rails.root.join('app', 'assets', 'images', 'misc', img))
    })
  end

  def execute_in_colab_url
    colab_url = nil
    if self.gist_id.present?
      colab_url = COLAB_URL + self.gist_username + '/' + self.gist_id
    end
    return colab_url
  end

  def download_notebook_url
    download_url = nil
    if self.notebook_s3_url.present?
      download_url = self.notebook_s3_url.delete_prefix(ENV['AWS_S3_URL'])
    end
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def submission_notebook_already_created?
    if (self.submission_id.present? && self.private == true && self.title == "Solution for submission #{self.submission_id}")
      return false if Post.where(submission_id: self.submission_id, private: true, title: "Solution for submission #{self.submission_id}").exists?
    end
    return true
  end
end
