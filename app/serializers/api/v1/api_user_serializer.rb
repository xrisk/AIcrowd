module Api
  module V1
    class ApiUserSerializer
      def initialize(participant:)
        @participant = participant
      end

      def serialize
        {
          id:          participant.id,
          username:    participant.name,
          first_name:  participant.first_name,
          last_name:   participant.last_name,
          affiliation: participant.affiliation,
          address:     participant.address,
          email:       participant.email,
          is_admin:    participant.admin?
        }
      end

      private

      attr_reader :participant
    end
  end
end
