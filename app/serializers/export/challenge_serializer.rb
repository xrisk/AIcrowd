module Export
  class ChallengeSerializer < ActiveModel::Serializer
    include ActionView::Helpers::AssetUrlHelper

    attributes *::Challenge::IMPORTABLE_FIELDS, :dataset_files_attributes, :submission_file_definitions_attributes,
               :challenge_partners_attributes, :challenge_rules_attributes, :challenge_rounds_attributes, :image_file

    def image_file
      ::Images::Base64EncodeService.new(image_url: object.image_file.url).call.value
    end

    def dataset_files_attributes
      object.dataset_files.map { |dataset_file| Export::DatasetFileSerializer.new(dataset_file).as_json }
    end

    def submission_file_definitions_attributes
      object.submission_file_definitions.map do |submission_file_definition|
        Export::SubmissionFileDefinitionSerializer.new(submission_file_definition).as_json
      end
    end

    def challenge_partners_attributes
      object.challenge_partners.map { |challenge_partner| Export::ChallengePartnerSerializer.new(challenge_partner).as_json }
    end

    def challenge_rules_attributes
      object.challenge_rules.map { |challenge_rule| Export::ChallengeRuleSerializer.new(challenge_rule).as_json }
    end

    def challenge_rounds_attributes
      object.challenge_rounds.map { |challenge_round| Export::ChallengeRoundSerializer.new(challenge_round).as_json }
    end
  end
end
