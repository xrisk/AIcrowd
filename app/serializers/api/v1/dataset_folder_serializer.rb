module Api
  module V1
    class DatasetFolderSerializer
      def initialize(dataset_folder:)
        @dataset_folder = dataset_folder
      end

      def serialize
        {
          id:             dataset_folder.id,
          title:          dataset_folder.title,
          description:    dataset_folder.description,
          directory_path: dataset_folder.directory_path,
          aws_access_key: dataset_folder.aws_access_key,
          aws_secret_key: dataset_folder.aws_secret_key,
          bucket_name:    dataset_folder.bucket_name,
          region:         dataset_folder.region,
          visible:        dataset_folder.visible,
          evaluation:     dataset_folder.evaluation
        }
      end

      private

      attr_reader :dataset_folder
    end
  end
end
