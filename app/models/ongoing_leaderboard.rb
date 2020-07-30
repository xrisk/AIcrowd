class OngoingLeaderboard < SqlView
  self.primary_key = :id
  after_initialize :readonly!

  include PolymorphicSubmitter
  belongs_to :challenge
  belongs_to :challenge_round
  belongs_to :submission, optional: true

  as_enum :leaderboard_type,
          [:leaderboard, :ongoing, :disentanglement],
          map: :string

  default_scope { order(seq: :asc) }

  scope :by_country, ->(country_name) { where(participants: { country_cd: Country.country_cd(country_name) }) }
  scope :by_affiliation, ->(affiliation) { where(participants: { affiliation: affiliation }) }
end
