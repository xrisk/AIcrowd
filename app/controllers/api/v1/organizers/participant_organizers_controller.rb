module Api
  module V1
    module Organizers
      class ParticipantOrganizersController < ::Api::V1::BaseController
        before_action :auth_by_admin_api_key
        before_action :set_participant_id_by_name, only: :create
        before_action :set_organizer, only: [:create, :destroy]
        before_action :set_participant_organizer, only: :destroy

        def create
          participant_organizer = @organizer.participant_organizers.new(participant_organizer_params)

          if participant_organizer.save
            render json: Api::V1::ParticipantOrganizerSerializer.new(participant_organizer: participant_organizer).serialize, status: :created
          else
            render json: { error: participant_organizer.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        def destroy
          @participant_organizer.destroy!

          head :ok
        end

        private

        def set_participant_id_by_name
          params[:participant_id] = Participant.find_by(name: params[:name])&.id if params[:name].present?
        end

        def set_organizer
          @organizer = Organizer.friendly.find(params[:organizer_id])
        end

        def set_participant_organizer
          @participant_organizer = @organizer.participant_organizers.find(params[:id])
        end

        def participant_organizer_params
          params.permit(
            :participant_id
          )
        end
      end
    end
  end
end
