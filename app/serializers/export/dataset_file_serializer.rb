module Export
  class DatasetFileSerializer < ActiveModel::Serializer
    attributes(*::Challenge::IMPORTABLE_ASSOCIATIONS[:dataset_files_attributes])
  end
end
