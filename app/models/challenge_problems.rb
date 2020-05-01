class ChallengeProblems < ApplicationRecord
  belongs_to :challenge
  has_many :problems, foreign_key: "problem_id", class_name: "ChallengeProblems"

  validates :problem_id, presence: true, allow_blank: false
  validates :weight, presence: true, allow_blank: false
  validates :challenge_round_id, presence: true, allow_blank: false
  validates_uniqueness_of :problem_id, :scope => [:challenge_id]
end
