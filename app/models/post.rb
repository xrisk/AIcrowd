class Post < ApplicationRecord
  has_many :likes, as: :reference, dependent: :destroy
  belongs_to :challenge, optional: true
  belongs_to :submission, optional: true
  mount_uploader :thumbnail, RawImageUploader
end
