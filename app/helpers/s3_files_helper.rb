module S3FilesHelper
  def s3_expiring_url(s3_key)
    s3_file_obj = Aws::S3::Object.new(bucket_name: ENV['AWS_S3_BUCKET'], key: s3_key)
    s3_file_obj.presigned_url(:get, expires_in: 7.days.to_i) if s3_file_obj&.key && !s3_file_obj.key.blank?
  end
end
