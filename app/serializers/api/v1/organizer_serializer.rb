module Api
  module V1
    class OrganizerSerializer
      def initialize(organizer:)
        @organizer = organizer
      end

      def serialize
        {
          id:                     organizer.id,
          organizer:              organizer.organizer,
          address:                organizer.address,
          description:            organizer.description,
          approved:               organizer.approved,
          slug:                   organizer.slug,
          image_file_url:         organizer.image_file&.url,
          tagline:                organizer.tagline,
          challenge_proposal:     organizer.challenge_proposal,
          clef_organizer:         organizer.clef_organizer,
          participant_organizers: participant_organizers,
          participants:           participants
        }
      end

      private

      attr_reader :organizer

      def participant_organizers
        organizer.participant_organizers.map { |participant_organizer| Api::V1::ParticipantOrganizerSerializer.new(participant_organizer: participant_organizer).serialize }
      end

      def participants
        organizer.participants.map { |participant| Api::V1::ParticipantSerializer.new(participant: participant).serialize }
      end
    end
  end
end
