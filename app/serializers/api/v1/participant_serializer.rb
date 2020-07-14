module Api
  module V1
    class ParticipantSerializer
      def initialize(participant:)
        @participant = participant
      end

      def serialize
        {
          id:                              participant.id,
          email:                           participant.email,
          name:                            participant.name,
          confirmed_at:                    participant.confirmed_at,
          admin:                           participant.admin,
          verified:                        participant.verified,
          bio:                             participant.bio,
          website:                         participant.website,
          github:                          participant.github,
          linkedin:                        participant.linkedin,
          twitter:                         participant.twitter,
          affiliation:                     participant.affiliation,
          country_cd:                      participant.country_cd,
          rating:                          participant.rating,
          agreed_to_marketing:             participant.agreed_to_marketing,
          agreed_to_organizers_newsletter: participant.agreed_to_organizers_newsletter
        }
      end

      private

      attr_reader :participant
    end
  end
end
