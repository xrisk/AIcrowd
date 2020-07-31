module Export
  class ChallengePartnerSerializer < ActiveModel::Serializer
    attributes(*::Challenge::IMPORTABLE_ASSOCIATIONS[:challenge_partners_attributes], :image_file)

    def image_file
      ::Images::Base64EncodeService.new(image_url: object.image_file.url).call.value
    end
  end
end
