class DisentanglementLeaderboard < ApplicationRecord
  include FreezeRecord

  belongs_to :challenge
  belongs_to :challenge_round
  belongs_to :participant, optional: true

  scope :by_country, ->(country_name) { where(participants: { country_cd: Participant.country_cd(country_name) }) }
  scope :by_affiliation, ->(affiliation) { where(participants: { affiliation: affiliation }) }
end
