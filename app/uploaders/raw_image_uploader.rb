INFINTY = 100000000
class RawImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  process :crop_image, :optimize, :resize_image

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

  def crop_image
    unless $coords_x.blank?
      manipulate! do |image|
        x = $coords_x.to_f
        y = $coords_y.to_f
        w = $coords_w.to_f
        h = $coords_h.to_f

        image.crop([[w, h].join('x'), [x, y].join('+')].join('+'))
        image
      end
    end

    unless $social_media_coords_x.blank?
      manipulate! do |image|
        x = $social_media_coords_x.to_f
        y = $social_media_coords_y.to_f
        w = $social_media_coords_w.to_f
        h = $social_media_coords_h.to_f

        image.crop([[w, h].join('x'), [x, y].join('+')].join('+'))
        image
      end
    end

    unless $banner_mobile_coords_x.blank?
      manipulate! do |image|
        x = $banner_mobile_coords_x.to_f
        y = $banner_mobile_coords_y.to_f
        w = $banner_mobile_coords_w.to_f
        h = $banner_mobile_coords_h.to_f

        image.crop([[w, h].join('x'), [x, y].join('+')].join('+'))
        image
      end
    end

    unless $banner_coords_x.blank?
      manipulate! do |image|
        x = $banner_coords_x.to_f
        y = $banner_coords_y.to_f
        w = $banner_coords_w.to_f
        h = $banner_coords_h.to_f

        image.crop([[w, h].join('x'), [x, y].join('+')].join('+'))
        image
      end
    end

  end

end
