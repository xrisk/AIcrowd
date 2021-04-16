class ChallengeProblems < ApplicationRecord
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :problem, class_name: 'Challenge'
  belongs_to :challenge_round, optional: true, class_name: 'ChallengeRound'
  has_many :problems, foreign_key: "problem_id", class_name: "ChallengeProblems"

  validates :problem_id, presence: true
  validates :weight, presence: true, allow_blank: false
  validates :challenge_round_id, presence: true, allow_blank: false
  validates :problem_id, presence: true, uniqueness: { scope: :challenge_id }

  after_commit :recalculate_leaderboard, on: [:update]

  def problem
    return Challenge.find(problem_id)
  end

  def recalculate_leaderboard
    if self.challenge_round_id.present?
      CalculateLeaderboardJob.perform_now(challenge_round_id: self.challenge_round_id)
    else
      CalculateLeaderboardJob.perform_now(challenge_round_id: challenge.active_round.id)
    end
  end

end
