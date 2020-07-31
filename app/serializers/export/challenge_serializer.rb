module Export
  class ChallengeSerializer < ActiveModel::Serializer
    include ActionView::Helpers::AssetUrlHelper

    attributes(*::Challenge::IMPORTABLE_FIELDS, :submission_file_definitions_attributes,
               :challenges_organizers_attributes, :category_challenges_attributes,
               :challenge_partners_attributes, :challenge_rules_attributes, :image_file,
               :banner_file, :dataset_files_attributes)

    def image_file
      ::Images::Base64EncodeService.new(image_url: object.image_file.url).call.value
    end

    def banner_file
      ::Images::Base64EncodeService.new(image_url: object.banner_file.url).call.value
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

    def challenges_organizers_attributes
      object.challenges_organizers.map { |challenges_organizer| Export::ChallengesOrganizerSerializer.new(challenges_organizer).as_json }
    end

    def category_challenges_attributes
      object.category_challenges.map { |category_challenge| Export::CategoryChallengeSerializer.new(category_challenge).as_json }
    end

    def dataset_files_attributes
      object.dataset_files.map { |dataset_file| Export::DatasetFileSerializer.new(dataset_file).as_json }
    end
  end
end
