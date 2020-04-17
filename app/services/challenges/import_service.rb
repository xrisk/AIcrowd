module Challenges
  class ImportService < ::BaseService
    def initialize(import_params:, challenge: nil)
      @import_params = import_params
      @challenge     = challenge || Challenge.new
    end

    def call
      return failure('Import failed: There are no params to import') if challenge_params.blank?

      drop_unwanted_associations
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

    attr_reader :import_params
    attr_accessor :challenge

    def challenge_params
      @challenge_params ||= import_params&.permit(*permitted_params)
    end

    def permitted_params
      ::Challenge::IMPORTABLE_FIELDS + ::Challenge::IMPORTABLE_ASSOCIATIONS.map { |key, value| { key => value } }
    end

    def drop_unwanted_associations
      Challenges::ImportConstants::IMPORTABLE_ASSOCIATIONS.keys.each do |association|
        association_name = association.to_s.remove('_attributes')
        challenge.public_send("#{association_name}=", [])
      end
    end

    def import_images_from_base64
      challenge.image_file = decode_base64_data(import_params[:image_file])

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
