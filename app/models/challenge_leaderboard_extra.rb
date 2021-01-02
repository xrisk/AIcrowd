class ChallengeLeaderboardExtra < ApplicationRecord
  belongs_to :challenge_round

  validates :ranking_window,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }
  validates :score_precision,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 0,
                            allow_nil:                true }
  validates :score_secondary_precision,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 0,
                            allow_nil:                true }

  as_enum :primary_sort_order, [:ascending, :descending], map: :string, prefix: true
  as_enum :secondary_sort_order, [:ascending, :descending, :not_used, :hidden], map: :string, prefix: true

  validates :primary_sort_order, presence: true
  validates :secondary_sort_order, presence: true
  validates :freeze_duration, numericality: { greater_than: 0 }, if: -> { freeze_duration.present? }

  after_save :recalculate_leaderboard, if: :saved_change_to_freeze_flag

  def get_score_title
    score_title.presence || 'Primary Score'
  end

  def get_score_secondary_title
    score_secondary_title.presence || 'Secondary Score'
  end

  def recalculate_leaderboard
    CalculateLeaderboardJob.perform_now(challenge_round_id: challenge_round.id) unless freeze_flag
  end

  def other_scores_fieldnames_array(display=false)
    if self.challenge_round.challenge.meta_challenge || self.challenge_round.challenge.ml_challenge
      return self.challenge_round.challenge.challenge_problems.pluck('challenge_round_id')
    end

    arr = other_scores_fieldnames&.split(',')&.map(&:strip)
    display_arr = other_scores_fieldnames_display&.split(',')&.map(&:strip)
    if display && arr.present? && display_arr.present? && arr.length == display_arr.length && display_arr.length > 0
      return display_arr
    elsif arr.present? && arr.length > 0
      return arr
    else
      return []
    end
  end
end
