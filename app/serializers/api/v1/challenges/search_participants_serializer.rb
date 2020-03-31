module Api
  module V1
    module Challenges
      class SearchParticipantsSerializer
        def initialize(participants:)
          @participants = participants
        end

        def serialize
          {
            results:    results,
            processing: processing
          }
        end

        private

        attr_reader :participants

        def results
          participants.map do |participant|
            {
              id:   participant.email,
              text: participant.name
            }
          end
        end

        def processing
          { more: false }
        end
      end
    end
  end
end
