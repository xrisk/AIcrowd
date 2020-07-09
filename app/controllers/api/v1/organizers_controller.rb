module Api
  module V1
    class OrganizersController < ::Api::V1::BaseController
      before_action :auth_by_participant_api_key

      def create
        organizer            = Organizer.new(organizer_params)
        organizer.image_file = decode_base64_data(organizer_params[:image_file])

        if organizer.save
          render json: Api::V1::OrganizerSerializer.new(organizer: organizer).serialize, status: :created
        else
          render json: { error: organizer.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      private

      def organizer_params
        params.permit(
          :organizer,
          :address,
          :description,
          :approved,
          :slug,
          :tagline,
          :challenge_proposal,
          :clef_organizer
        )
      end

      def decode_base64_data(base64_data)
        result = Images::Base64DecodeService.new(base64_data: base64_data).call

        return result.value if result.success?
      end
    end
  end
end
