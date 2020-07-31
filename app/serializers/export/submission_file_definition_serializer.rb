module Export
  class SubmissionFileDefinitionSerializer < ActiveModel::Serializer
    attributes(*::Challenge::IMPORTABLE_ASSOCIATIONS[:submission_file_definitions_attributes])
  end
end
