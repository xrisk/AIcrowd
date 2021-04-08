class TeamParticipant < ApplicationRecord
  ROLES = [:member, :organizer].freeze

  belongs_to :team, inverse_of: :team_participants
  belongs_to :participant, inverse_of: :teams

  as_enum :role, ROLES, map: :string, source: :role, prefix: true

  validates :role, inclusion: { in: ROLES }

  after_commit :recalculate_leaderboard, on: [:create, :update]

  def recalculate_leaderboard
    self.team.challenge.challenge_rounds.each do |challenge_round|
      CalculateLeaderboardJob.perform_now(challenge_round_id: challenge_round.id)
    end
  end

end
