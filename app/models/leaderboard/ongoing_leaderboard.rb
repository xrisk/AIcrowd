class OngoingLeaderboard < SqlView
  self.primary_key = :id
  after_initialize :readonly!

  include PolymorphicSubmitter

  belongs_to :challenge

  default_scope { order(seq: :asc) }
  scope :by_country, ->(country_name) { where(participants: { country_cd: Participant.country_cd(country_name) }) }
  scope :by_affiliation, ->(affiliation) { where(participants: { affiliation: affiliation }) }
end
