module DatasetFilesHelper
  def file_info(file)
    "#{file.dataset_file_file_name} (#{number_to_human_size(file.dataset_file_file_size)})"
  end

  def dataset_file_expiring_url(dataset_file)
    if dataset_file.hosting_location == 'External'
      return dataset_file.external_url
    else
      if get_s3_file_obj(dataset_file)
        return get_s3_file_obj(dataset_file).presigned_url(:get, expires_in: 7.days.to_i)
      else
        return '#'
      end
    end
  end

  def dataset_file_title(dataset_file)
    dataset_file.title.presence || dataset_file.description
  end

  def dataset_file_size(dataset_file)
    if dataset_file.hosting_location == 'External'
      dataset_file.external_file_size
    else
      return 0 if get_s3_file_obj(dataset_file).nil? || !get_s3_file_obj(dataset_file).exists?

      number_to_human_size(get_s3_file_obj(dataset_file).content_length)
    end
  end

  private

  def get_s3_file_obj(dataset_file)
    s3_key = dataset_file.dataset_file_s3_key
    return nil if s3_key.nil?

    s3_file_obj = Aws::S3::Object.new(bucket_name: ENV['AWS_S3_BUCKET'], key: s3_key)
    if s3_file_obj&.key && !s3_file_obj.key.blank?
      return s3_file_obj
    else
      return nil
    end
  end
end
