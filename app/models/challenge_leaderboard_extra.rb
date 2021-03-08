class ChallengeLeaderboardExtra < ApplicationRecord
  belongs_to :challenge_round, touch: true
  belongs_to :challenge, optional: true

  validates :ranking_window,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }
  validates :score_precision,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 0,
                            allow_nil:                false }
  validates :score_secondary_precision,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 0,
                            allow_nil:                false }

  as_enum :primary_sort_order, [:ascending, :descending], map: :string, prefix: true
  as_enum :secondary_sort_order, [:ascending, :descending, :not_used, :hidden], map: :string, prefix: true

  validates :primary_sort_order, presence: true
  validates :secondary_sort_order, presence: true
  validates :freeze_duration, numericality: { greater_than: 0 }, if: -> { freeze_duration.present? }

  before_save :set_challenge_for_leaderboard
  after_save :recalculate_leaderboard, if: :saved_change_to_freeze_flag
  after_commit :update_challenge_media, if: :saved_change_to_media_on_leaderboard

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

  def update_challenge_media
    if self.challenge_id.present?
      self.challenge.update!(media_on_leaderboard: self.media_on_leaderboard)
    end
  end

  def set_challenge_for_leaderboard
    if self.challenge_id.blank?
      self.challenge_id = self.challenge_round.challenge_id
    end
  end
end
