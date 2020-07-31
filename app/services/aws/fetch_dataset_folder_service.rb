module Aws
  class FetchDatasetFolderService < ::Aws::BaseService
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
      client = if dataset_folder.aws_endpoint.present?
                 Aws::S3::Resource.new(
                   region:      dataset_folder.region.presence || ENV['AWS_REGION'],
                   credentials: Aws::Credentials.new(
                     dataset_folder.aws_access_key,
                     dataset_folder.aws_secret_key
                   ),
                   endpoint:    dataset_folder.aws_endpoint
                 )
               else
                 Aws::S3::Resource.new(
                   region:      dataset_folder.region.presence || ENV['AWS_REGION'],
                   credentials: Aws::Credentials.new(
                     dataset_folder.aws_access_key,
                     dataset_folder.aws_secret_key
                   )
                 )
               end
    end

    def build_dataset_file(aws_file)
      DatasetFile.new(
        title:              file_title(aws_file[:url]),
        external_url:       aws_file[:url],
        external_file_size: aws_file[:size]
      )
    end

    def file_title(file_url)
      uri = URI.parse(file_url)
      uri.path.split('/').last
    end
  end
end
