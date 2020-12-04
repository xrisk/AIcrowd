module Api
  module V1
    class ChallengeRoundSerializer
      def initialize(challenge_round:)
        @challenge_round = challenge_round
      end

      def serialize
        {
          id:                         challenge_round.id,
          challenge_round:            challenge_round.challenge_round,
          active:                     challenge_round.active,
          submission_limit:           challenge_round.submission_limit,
          submission_limit_period_cd: challenge_round.submission_limit_period_cd,
          start_dttm:                 challenge_round.start_dttm,
          end_dttm:                   challenge_round.end_dttm,
          minimum_score:              challenge_round.minimum_score,
          minimum_score_secondary:    challenge_round.minimum_score_secondary
        }
      end

      private

      attr_reader :challenge_round
    end
  end
end
