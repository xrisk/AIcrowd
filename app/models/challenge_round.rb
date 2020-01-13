class ChallengeRound < ApplicationRecord
  include Markdownable

  belongs_to :challenge, inverse_of: :challenge_rounds
  has_many :submissions,
           dependent: :restrict_with_error
  has_many :leaderboards
  after_initialize :defaults,
                   unless: :persisted?

  validates :challenge_round, presence: true
  validates :submission_limit,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }
  validates :ranking_window,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }
  validates :ranking_highlight,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }
  validates :score_precision,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }
  validates :score_secondary_precision,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }

  validates :submission_limit, presence: true
  validates :submission_limit_period, presence: true

  as_enum :submission_limit_period,
          [:day, :week, :round], map: :string

  default_scope { order :start_dttm }

  def defaults
    self.challenge_round           ||= 'Round 1'
    self.ranking_window            ||= 96
    self.ranking_highlight         ||= 3
    self.score_precision           ||= 3
    self.score_secondary_precision ||= 3
  end
end
