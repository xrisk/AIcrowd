module Challenges
  class ImportService < ::BaseService
    def initialize(import_params:, challenge: nil)
      @import_params = import_params
      @challenge     = challenge || Challenge.new
    end

    def call
      return failure('Import failed: There are no params to import') if challenge_params.blank?

      reset_associations
      remove_ids_from_not_existing_records

      @challenge.attributes = challenge_params

      return failure('Import failed: At least one organizer must be provided') if @challenge.challenges_organizers.none?

      @challenge = import_images_from_base64

      if @challenge.save
        success(@challenge)
      else
        failure("Import failed: #{@challenge.errors.full_messages.to_sentence}")
      end
    end

    private

    attr_accessor :challenge, :import_params

    def challenge_params
      import_params&.permit(*permitted_params)
    end

    def permitted_params
      ::Challenge::IMPORTABLE_FIELDS + ::Challenge::IMPORTABLE_ASSOCIATIONS.map { |key, value| { key => value } }
    end

    def reset_associations
      Challenges::ImportConstants::RESETTABLE_ASSOCIATIONS.each do |association|
        challenge.public_send("#{association}=", []) if import_params["#{association}_attributes"].present?
      end
    end

    def remove_ids_from_not_existing_records
      import_params[:dataset_files_attributes]&.each do |dataset_file|
        dataset_file[:id] = nil unless DatasetFile.exists?(id: dataset_file[:id], challenge_id: challenge.id)
      end
    end

    def import_images_from_base64
      challenge.image_file  = decode_base64_data(import_params[:image_file])
      challenge.banner_file = decode_base64_data(import_params[:banner_file])

      ::Challenge::IMPORTABLE_IMAGES.each do |element|
        if element.is_a?(Symbol) # :field_name
          # Assign decoded image to challenge fields
          challenge.public_send("#{element}=", decode_base64_data(import_params[element]))
        elsif element.is_a?(Hash) # { association_name: :field_name }
          association_name = element.keys.first
          field_name       = element.values.first

          # Assign decoded image to associations fields
          challenge.public_send(association_name).each_with_index do |association, index|
            association.public_send("#{field_name}=", decode_base64_data(import_params["#{association_name}_attributes"][index][field_name]))
          end
        end
      end

      challenge
    end

    def decode_base64_data(base64_data)
      result = Images::Base64DecodeService.new(base64_data: base64_data).call

      return result.value if result.success?
    end
  end
end
