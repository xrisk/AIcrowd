module Api
  module V1
    module Challenges
      class SearchNewsletterEmailsSerializer
        def initialize(groups:, teams:, participants:, challenge_rounds:)
          @groups           = groups
          @teams            = teams
          @participants     = participants
          @challenge_rounds = challenge_rounds
        end

        def serialize
          {
            results:    results,
            processing: processing
          }
        end

        private

        attr_reader :teams, :participants, :challenge_rounds, :groups

        def results
          [
            {
              text:     'Groups',
              children: groups_results
            },
            {
              text:     'Teams',
              children: teams_results
            },
            {
              text:     'Users',
              children: participants_results
            }
          ]
        end

        def groups_results
          groups + challenge_rounds_groups
        end

        def teams_results
          teams.map do |team|
            {
              id:   team.participants&.pluck(:email)&.join(',').to_s,
              text: team.name
            }
          end
        end

        def participants_results
          participants.map do |participant|
            {
              id:   participant.email,
              text: participant.name
            }
          end
        end

        def challenge_rounds_groups
          challenge_rounds.map do |challenge_round|
            {
              id:   "challenge_round_#{challenge_round.id}",
              text: "Participants of \"#{challenge_round.challenge_round}\""
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
