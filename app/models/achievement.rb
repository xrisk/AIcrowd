class Achievement < ApplicationRecord
  belongs_to :participant
  belongs_to :challenge_round
end
