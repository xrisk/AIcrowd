module Api
  module V1
    class FeedbackSerializer
      def initialize(feedback:)
        @feedback = feedback
      end

      def serialize
        {
          id:               feedback.id,
          message:          feedback.message,
          participant_name: feedback.participant.name
        }
      end

      private

      attr_reader :feedback
    end
  end
end
