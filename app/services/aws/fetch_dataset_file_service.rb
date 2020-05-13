module Aws
  class FetchDatasetFileService < ::Aws::BaseService
    DEFAULT_NOT_FOUND_MESSAGE = 'File under specified file path does not exist.'.freeze
    DEFAULT_ERROR_MESSAGE     = 'AWS credentials or bucket name are incorrect.'.freeze

    def initialize(dataset_file:)
      @dataset_file = dataset_file
    end

    def call
      object   = get_s3_object
      aws_file = aws_file(object)

      success(aws_file)
    rescue Aws::S3::Errors::NotFound => e
      aws_logger.error(DEFAULT_NOT_FOUND_MESSAGE)
      failure(DEFAULT_NOT_FOUND_MESSAGE)
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
  end
end
