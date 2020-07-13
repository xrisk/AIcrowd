module Api
  module V1
    class ParticipantOrganizerSerializer
      def initialize(participant_organizer:)
        @participant_organizer = participant_organizer
      end

      def serialize
        {
          id:             participant_organizer.id,
          organizer_id:   participant_organizer.organizer_id,
          participant_id: participant_organizer.participant_id
        }
      end

      private

      attr_reader :participant_organizer
    end
  end
end
