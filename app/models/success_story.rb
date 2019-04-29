class SuccessStory < ApplicationRecord
	include FriendlyId

	friendly_id :challenge,
	use: [:slugged]
	mount_uploader :image_file, ImageUploader
	validates_presence_of :posted_at
end
