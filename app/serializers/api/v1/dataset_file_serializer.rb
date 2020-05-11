module Api
  module V1
    class DatasetFileSerializer
      def initialize(dataset_file:)
        @dataset_file = dataset_file
      end

      def serialize
        {
          id:                  dataset_file.id,
          seq:                 dataset_file.seq,
          title:               dataset_file.title,
          description:         dataset_file.description,
          visible:             dataset_file.visible,
          evaluation:          dataset_file.evaluation,
          hosting_location:    dataset_file.hosting_location,
          dataset_file_s3_key: dataset_file.dataset_file_s3_key,
          external_url:        dataset_file.external_url,
          external_file_size:  dataset_file.external_file_size
        }
      end

      private

      attr_reader :dataset_file
    end
  end
end
