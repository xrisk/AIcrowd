class LogoImageUploader < CarrierWave::Uploader::Base
  include ActionView::Helpers::AssetUrlHelper
  include CarrierWave::MiniMagick
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
    if model.class.name == 'Challenge' && model.id
      num = model.id % 2
      "challenges/AIcrowd-ProblemStatements-#{num}.jpg"
    else
      '/assets/users/user-avatar-default.svg'
    end
  end
end
