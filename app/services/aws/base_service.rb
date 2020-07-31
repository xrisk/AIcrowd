module Aws
  class BaseService < ::BaseService
    HANDLED_AWS_ERRORS  = [
      Aws::S3::Errors::InvalidAccessKeyId,
      Aws::S3::Errors::SignatureDoesNotMatch,
      Aws::Errors::NoSuchEndpointError,
      Aws::Errors::MissingRegionError,
      Aws::Errors::MissingCredentialsError,
      Aws::S3::Errors::Forbidden,
      Aws::S3::Errors::NoSuchBucket,
      Aws::S3::Errors::BadRequest,
      Aws::S3::Errors::ServiceError
    ].freeze
    DEFAULT_EXPIRY_TIME = 1.day.freeze
    LOGGER_URL          = 'log/aws_s3_api.log'.freeze

    protected

    def aws_file(aws_object)
      { url: aws_object.presigned_url(:get, expires_in: DEFAULT_EXPIRY_TIME), size: aws_object.content_length }
    end

    def aws_logger
      Logger.new(LOGGER_URL)
    end
  end
end
