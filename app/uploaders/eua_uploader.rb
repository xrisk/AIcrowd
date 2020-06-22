class EuaUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "EUAs/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    if original_filename.present?
      @unique_filename ||= "#{File.basename(original_filename.to_s, File.extname(original_filename.to_s))}_#{SecureRandom.uuid}.#{file&.extension}"
    end
  end

  def extension_whitelist
    ['pdf']
  end
end
