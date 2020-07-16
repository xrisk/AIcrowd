module Api
  module V1
    class ParticipantSerializer
      def initialize(participant:)
        @participant = participant
      end

      def serialize
        {
          id:   participant.id,
          name: participant.name
        }
      end

      private

      attr_reader :participant
    end
  end
end
