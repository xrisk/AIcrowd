class ImageUploadJob < ApplicationJob
  queue_as :images
  include ::CarrierWave::Workers::ProcessAssetMixin
end