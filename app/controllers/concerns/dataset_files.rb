module Concerns
  module DatasetFiles
    extend ActiveSupport::Concern

    private

    def set_dataset_files
      @dataset_files = policy_scope(DatasetFile).where(challenge_id: @challenge.id)
      @dataset_files = @dataset_files.map do |dataset_file|
        next dataset_file if dataset_file.hosting_location != 'Own S3'

        result = Rails.cache.fetch(dataset_file_cache_key(dataset_file), expires_in: 5.minutes) do
          Aws::FetchDatasetFileService.new(dataset_file: dataset_file).call
        end

        if result.success?
          dataset_file.external_url       = result.value[:url]
          dataset_file.external_file_size = result.value[:size]
        else
          dataset_file.error_message = result.value
        end

        dataset_file
      end
    end

    def set_dataset_folders
      @dataset_folders = policy_scope(DatasetFolder).where(challenge_id: @challenge.id)
      @dataset_folders.each do |dataset_folder|
        result = Rails.cache.fetch(dataset_folder_cache_key(dataset_folder), expires_in: 5.minutes) do
          Aws::FetchDatasetFolderService.new(dataset_folder: dataset_folder).call
        end

        if result.success?
          dataset_folder.dataset_files = result.value
        else
          dataset_folder.error_message = result.value
        end
      end
    end

    def dataset_folder_cache_key(dataset_folder)
      "aws-dataset-folder/#{dataset_folder.id}-#{dataset_folder.updated_at.to_i}"
    end

    def dataset_file_cache_key(dataset_file)
      "aws-dataset-file/#{dataset_file.id}-#{dataset_file.updated_at.to_i}"
    end
  end
end
