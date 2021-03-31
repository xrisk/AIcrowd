class ImageUploadJob < ApplicationJob
  include ::CarrierWave::Workers::ProcessAssetMixin
end