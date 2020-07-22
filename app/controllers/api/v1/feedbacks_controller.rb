module Api
  module V1
    class FeedbacksController < ActionController::API
      def create
        feedback = Feedback.new(feedback_params)

        if feedback.save
          render json: Api::V1::FeedbackSerializer.new(feedback: feedback).serialize, status: :created
        else
          render json: { error: feedback.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      private

      def feedback_params
        params.permit(:message).merge(participant: current_participant)
      end
    end
  end
end
