class ImageUploader < CarrierWave::Uploader::Base
  include ActionView::Helpers::AssetUrlHelper
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  process :optimize, :resize_image
  # https://github.com/DarthSim/carrierwave-bombshelter

  storage :fog

  def store_dir
    "images/#{model.class.to_s.pluralize.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    ['jpg', 'jpeg', 'gif', 'png']
  end

  def default_url
    "#{ENV['DOMAIN_NAME']}#{asset_url(get_default_image)}"
  end

  def get_default_image
    if model.class.name == 'Participant'
      num = model.id % 8
      "/assets/users/AIcrowd-DarkerBG (#{num}).png"
    elsif model.class.name == 'Challenge' && model.id
      num = model.id % 2
      "/assets/challenges/AIcrowd-ProblemStatements-#{num}.jpg"
    else
      '/assets/users/user-avatar-default.svg'
    end
  end

  def resize_image
    if self.model.class.name == "Participant"
      resize_to_fit(500, 1000000)
    elsif self.model.class.name == "Challenge"
      if self.model.big_challenge_card_image
        resize_to_fit(1540, 1000000)
      else
        resize_to_fit(441, 1000000)
      end
    end
  end
end
