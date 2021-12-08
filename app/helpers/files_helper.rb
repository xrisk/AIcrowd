module FilesHelper
  def file_track_url(file, folder)
    data = {
      'file': file.id,
      'file_path': file.title,
      'folder': folder&.id.presence || '',
    }
    if !current_participant.present?
      return new_participant_session_path
    end

    dfd = DatasetFileDownload.create!(participant_id: current_participant.id,
                                ip_address: request.remote_ip,
                                external_url: file_expiring_url(file),
                                dataset_file_id: file&.id.presence || 0,
                                dataset_folder_id: folder&.id.presence || 0,
                                dataset_folder_path: file.title,
                                downloaded: false
    )
    return "?unique_download_uri=#{dfd.id}"
  end

  def file_expiring_url(file)
    if file.try(:hosting_location) == 'External' || file.try(:hosting_location) == 'Own S3' || file.new_record?
      return file.external_url
    else
      if get_s3_file_obj(file)
        return get_s3_file_obj(file).presigned_url(:get, expires_in: 1.day.to_i)
      else
        return '#'
      end
    end
  end

  def file_title(file)
    file.title.presence || file.description
  end

  def file_size(file)
    if file.try(:hosting_location) == 'Own S3' || file.new_record?
      return number_to_human_size(file.external_file_size.to_i)
    elsif file.try(:hosting_location) == 'External'
      if file.external_file_size.present?
        return file.external_file_size
      end
    else
      return 0 if get_s3_file_obj(file).nil? || !get_s3_file_obj(file).exists?
      return number_to_human_size(get_s3_file_obj(file).content_length)
    end
    return nil
  end

  private

  def get_s3_file_obj(file)
    s3_key = file.dataset_file_s3_key
    return nil if s3_key.nil?

    s3_file_obj = Aws::S3::Object.new(bucket_name: ENV['AWS_S3_BUCKET'], key: s3_key)
    if s3_file_obj&.key && !s3_file_obj.key.blank?
      return s3_file_obj
    else
      return nil
    end
  end
end
