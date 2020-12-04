class ChallengeRound < ApplicationRecord
  before_update :rollback_rating, :if => :end_dttm_changed?
  include Markdownable

  belongs_to :challenge, inverse_of: :challenge_rounds
  has_many :submissions, dependent: :restrict_with_error
  has_many :leaderboards
  has_many :user_ratings
  has_many :challenge_leaderboard_extras
  has_one :default_leaderboard, -> { where("challenge_leaderboard_extras.default IS TRUE") }, class_name: "ChallengeLeaderboardExtra"
  has_many :extra_leaderboards, -> { where("challenge_leaderboard_extras.default IS FALSE") }, class_name: "ChallengeLeaderboardExtra"
  accepts_nested_attributes_for :challenge_leaderboard_extras

  as_enum :submissions_type, [:artifact, :code, :gitlab], map: :string

  validates :submissions_type, presence: true
  validates :challenge_round, presence: true
  validates :submission_limit,
            numericality: { only_integer:             true,
                            greater_than_or_equal_to: 1,
                            allow_nil:                true }

  validates :submission_limit, presence: true
  validates :submission_limit_period, presence: true

  as_enum :submission_limit_period, [:day, :week, :round], map: :string
  as_enum :debug_submission_limit_period, [:day, :week, :round], map: :string
  as_enum :primary_sort_order, [:ascending, :descending], map: :string, prefix: true
  as_enum :secondary_sort_order, [:ascending, :descending, :not_used, :hidden], map: :string, prefix: true

  default_scope { order :start_dttm }
  scope :started, -> { where("start_dttm < ?", Time.current) }

  after_save :create_default_leaderboard

  after_initialize :set_defaults

  def rollback_rating
    RollbackRatingJob.perform_later(end_dttm_was.to_s)
  end

  def set_defaults
    if new_record?
      self.challenge_round ||= "Round #{(challenge&.challenge_rounds&.count || 0) + 1}"
      self.start_dttm      ||= Time.now.utc
      self.end_dttm        ||= self.start_dttm + 3.months
    end
  end

  def recalculate_leaderboard
    CalculateLeaderboardJob.perform_now(challenge_round_id: id) unless freeze_flag
  end

  def create_default_leaderboard
    leaderboard = ChallengeLeaderboardExtra.where(default: true, challenge_round_id: id, challenge_id: challenge.id).first_or_initialize
    leaderboard.save!
  end

end
