module FilesHelper
  def file_expiring_url(file)
    if file.try(:hosting_location) == 'External' || file.try(:hosting_location) == 'Own S3' || file.new_record?
      file.external_url
    else
      if get_s3_file_obj(file)
        get_s3_file_obj(file).presigned_url(:get, expires_in: 1.day.to_i)
      else
        '#'
      end
    end
  end

  def file_title(file)
    file.title.presence || file.description
  end

  def file_size(file)
    if file.try(:hosting_location) == 'Own S3' || file.new_record?
      number_to_human_size(file.external_file_size.to_i)
    elsif file.try(:hosting_location) == 'External'
      file.external_file_size
    else
      return 0 if get_s3_file_obj(file).nil? || !get_s3_file_obj(file).exists?

      number_to_human_size(get_s3_file_obj(file).content_length)
    end
  end

  private

  def get_s3_file_obj(file)
    s3_key = file.dataset_file_s3_key
    return nil if s3_key.nil?

    s3_file_obj = Aws::S3::Object.new(bucket_name: ENV['AWS_S3_BUCKET'], key: s3_key)
    s3_file_obj if s3_file_obj&.key && !s3_file_obj.key.blank?
  end
end
