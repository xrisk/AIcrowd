module Aws
  class FetchDatasetFileService < ::Aws::BaseService
    DEFAULT_NOT_FOUND_MESSAGE = 'File under specified path and credentials does not exist.'.freeze
    DEFAULT_ERROR_MESSAGE     = 'AWS credentials, bucket name or region are incorrect.'.freeze

    def initialize(dataset_file:)
      @dataset_file = dataset_file
    end

    def call
      object = get_s3_object

      if object.exists?
        success(aws_file(object))
      else
        file_not_found_result
      end
    rescue Aws::S3::Errors::NotFound => e
      file_not_found_result
    rescue *HANDLED_AWS_ERRORS => e
      aws_logger.error(DEFAULT_ERROR_MESSAGE)
      failure(DEFAULT_ERROR_MESSAGE)
    end

    attr_reader :dataset_file

    def get_s3_object
      Aws::S3::Object.new(
        bucket_name: dataset_file.bucket_name,
        key:         dataset_file.file_path,
        region:      dataset_file.region,
        credentials: Aws::Credentials.new(
          dataset_file.aws_access_key,
          dataset_file.aws_secret_key
        )
      )
    end

    def file_not_found_result
      aws_logger.error(DEFAULT_NOT_FOUND_MESSAGE)
      failure(DEFAULT_NOT_FOUND_MESSAGE)
    end
  end
end
