class UserRating < ApplicationRecord
  belongs_to :participant
  belongs_to :challenge_round, optional: true
end
