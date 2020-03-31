module Api
  module V1
    module Challenges
      class SearchTeamsSerializer
        def initialize(teams:)
          @teams = teams
        end

        def serialize
          {
            results:    results,
            processing: processing
          }
        end

        private

        attr_reader :teams

        def results
          teams.map do |team|
            {
              id:   team.participants&.pluck(:email)&.join(',').to_s,
              text: team.name
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
