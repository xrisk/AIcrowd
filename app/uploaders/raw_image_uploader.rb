INFINTY = 100000000
class RawImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process :optimize, :resize_image

  storage :fog

  def store_dir
    "raw_images/#{model.class.to_s.pluralize.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    ['jpg', 'jpeg', 'gif', 'png', 'svg']
  end

  def filename
    random_token = Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.id.to_s}").first(20)
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    "#{token}.#{file.extension}" if original_filename
  end

  def resize_image
    if self.model.class.name == "Challenge"
      if self.mounted_as == :social_media_image_file
        resize_to_fit(1200, INFINTY)
      elsif self.mounted_as == :banner_file
        resize_to_fit(5315, INFINTY)
      elsif self.mounted_as == :banner_mobile_file
        resize_to_fit(1540, INFINTY)
      end
    end
  end
end
