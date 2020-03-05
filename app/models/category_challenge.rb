class CategoryChallenge < ApplicationRecord
  belongs_to :category
  belongs_to :challenge
  validates :challenge_id, uniqueness: { scope: :category_id }
  validates :challenge_id, :category_id, presence: true
end
