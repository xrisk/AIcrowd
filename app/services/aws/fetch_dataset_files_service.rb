module Aws
  class FetchDatasetFilesService < ::BaseService
    HANDLED_AWS_ERRORS = [
      Aws::S3::Errors::InvalidAccessKeyId,
      Aws::S3::Errors::SignatureDoesNotMatch,
      Aws::Errors::NoSuchEndpointError,
      Aws::S3::Errors::NoSuchBucket,
      Aws::S3::Errors::ServiceError
    ].freeze
    DEFAULT_EXPIRY_TIME = 1.day.freeze
    LOGGER_URL          = 'log/aws_s3_api.log'.freeze

    def initialize(dataset_folder:)
      @dataset_folder = dataset_folder
      @client         = build_aws_s3_client
    end

    def call
      objects_with_prefix    = client.bucket(dataset_folder.bucket_name).objects(prefix: dataset_folder.directory_path).to_a
      # Remove folder from objects list
      objects_without_folder = objects_with_prefix.reject { |aws_object| dataset_folder.directory_path.remove('/') == aws_object.key.remove('/') }
      aws_files              = objects_without_folder.map { |aws_object| aws_file(aws_object) }
      dataset_files          = aws_files.map { |aws_file| build_dataset_file(aws_file) }

      success(dataset_files)
    rescue *HANDLED_AWS_ERRORS => e
      aws_logger.error(e.message)
      failure(e.message)
    end

    attr_reader :dataset_folder, :client

    def build_aws_s3_client
      Aws::S3::Resource.new(
        region:      dataset_folder.region,
        credentials: Aws::Credentials.new(
          dataset_folder.aws_access_key,
          dataset_folder.aws_secret_key
        )
      )
    end

    def aws_file(aws_object)
      { url: aws_object.presigned_url(:get, expires_in: DEFAULT_EXPIRY_TIME), size: aws_object.content_length }
    end

    def build_dataset_file(aws_file)
      DatasetFile.new(
        title:              file_title(aws_file[:url]),
        external_url:       aws_file[:url],
        external_file_size: aws_file[:size]
      )
    end

    def file_title(file_url)
      uri = URI::parse(file_url)
      uri.path.split('/').last
    end

    def aws_logger
      Logger.new(LOGGER_URL)
    end
  end
end
