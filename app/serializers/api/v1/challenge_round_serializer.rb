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
          minimum_score_secondary:    challenge_round.minimum_score_secondary,
          ranking_window:             challenge_round.ranking_window,
          ranking_highlight:          challenge_round.ranking_highlight,
          score_precision:            challenge_round.score_precision,
          score_secondary_precision:  challenge_round.score_secondary_precision,
          leaderboard_note_markdown:  challenge_round.leaderboard_note_markdown,
          leaderboard_note:           challenge_round.leaderboard_note,
          score_title:                challenge_round.score_title,
          score_secondary_title:      challenge_round.score_secondary_title,
          primary_sort_order_cd:      challenge_round.primary_sort_order_cd,
          secondary_sort_order_cd:    challenge_round.secondary_sort_order_cd
        }
      end

      private

      attr_reader :challenge_round
    end
  end
end
