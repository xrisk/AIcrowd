class Partner < ApplicationRecord
  belongs_to :organizer, optional: true
  mount_uploader :image_file, RawImageUploader
  process_in_background :image_file, ImageUploadJob
end
