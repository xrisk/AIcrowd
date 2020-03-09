module Challenges
  class ImportService < ::BaseService
    def initialize(import_file:, organizers:)
      @import_file = import_file
      @organizers  = organizers
    end

    def call
      return failure('Import failed: File not selected') if import_file.blank?

      new_challenge            = Challenge.new(import_challenge_params)
      new_challenge            = import_images_from_base64(new_challenge)
      new_challenge.organizers = organizers

      if new_challenge.save
        success(new_challenge)
      else
        failure("Import failed: #{new_challenge.errors.full_messages.to_sentence}")
      end
    rescue JSON::ParserError => e
      failure("Import failed: #{e.message}")
    end

    private

    attr_reader :import_file, :organizers

    def json_data
      @json_data ||= JSON.load(import_file).with_indifferent_access
    end

    def import_images_from_base64(new_challenge)
      new_challenge.image_file = decode_base64_data(json_data[:image_file])

      ::Challenge::IMPORTABLE_IMAGES.each do |element|
        if element.is_a?(Symbol) # :field_name
           # Assign decoded image to challenge fields
          new_challenge.public_send("#{element}=", decode_base64_data(json_data[element]))
        elsif element.is_a?(Hash) # { association_name: :field_name }
          association_name = element.keys.first
          field_name       = element.values.first

          # Assign decoded image to associations fields
          new_challenge.public_send(association_name).each_with_index do |association, index|
            association.public_send("#{field_name}=", decode_base64_data(json_data["#{association_name}_attributes"][index][field_name]))
          end
        end
      end

      new_challenge
    end

    def import_challenge_params
      permitted_params = ::Challenge::IMPORTABLE_FIELDS + ::Challenge::IMPORTABLE_ASSOCIATIONS.map { |key, value| { key => value } }

      ActionController::Parameters.new(json_data).permit(*permitted_params)
    end

    def decode_base64_data(base64_data)
      result = Images::Base64DecodeService.new(base64_data: base64_data).call

      return result.value if result.success?
    end
  end
end
