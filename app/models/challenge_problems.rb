class ChallengeProblems < ApplicationRecord
  belongs_to :challenge
  has_many :problems, foreign_key: "problem_id", class_name: "ChallengeProblems"

  validates :problem_id, presence: true
  validates :weight, presence: true, allow_blank: false
  validates :challenge_round_id, presence: true, allow_blank: false
  validates :problem_id, presence: true, uniqueness: { scope: :challenge_id }

  def problem
    return Challenge.find(problem_id)
  end
end
