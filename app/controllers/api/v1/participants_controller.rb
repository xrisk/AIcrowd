module Api
  module V1
    class ParticipantsController < ActionController::API
      include ActionController::Helpers
      helper ParticipantsHelper

      def user_profile
        username    = params[:username]
        avatar      = params[:avatar]
        participant = Participant.find_by(id: params[:id])
        render partial: 'participants/user_link', locals: { participant: participant, username: username, avatar: avatar }, layout: false
      end
    end
  end
end
