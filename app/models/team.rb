class Team < ApplicationRecord
  belongs_to :challenge, inverse_of: :teams

  has_many :team_participants, inverse_of: :team, dependent: :destroy
  has_many :team_invitations, inverse_of: :team, dependent: :destroy

  has_many :participants, through: :team_participants, inverse_of: :teams

  scope :allowing_invitations, -> { where(invitations_allowed: true) }
  scope :with_at_least_n_participants, -> (n) { where(id:
    Team.joins(:team_participants)
      .group('teams.id')
      .having('count(team_participant_id) > ?', n)
      .select('teams.id')
  ) }

  validates_uniqueness_of :name, scope: :challenge_id # case-insensitive because name is a citext
  validates_length_of :name, in: 2...256
  validates_format_of :name,
    with: /(?=.*[a-zA-Z])/,
    message: 'must have at least one letter'
  validates_format_of :name,
    with: /\A[a-zA-Z0-9.\-_{}\[\]]+\z/,
    message: 'may only contain letters and numbers and these quoted characters: "-_.{}[]"'

  def to_param
    name
  end
end
