class EuaUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "EUAs/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    full_name = original_filename.to_s

    "#{File.basename(full_name, File.extname(full_name))}_#{SecureRandom.uuid}.#{file&.extension}"
  end

  def extension_whitelist
    ['pdf']
  end
end
