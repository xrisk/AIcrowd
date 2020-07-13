module Api
  module V1
    class OrganizerSerializer
      def initialize(organizer:)
        @organizer = organizer
      end

      def serialize
        {
          id:                 organizer.id,
          organizer:          organizer.organizer,
          address:            organizer.address,
          description:        organizer.description,
          approved:           organizer.approved,
          slug:               organizer.slug,
          image_file_url:     organizer.image_file&.url,
          tagline:            organizer.tagline,
          challenge_proposal: organizer.challenge_proposal,
          clef_organizer:     organizer.clef_organizer
        }
      end

      private

      attr_reader :organizer
    end
  end
end
