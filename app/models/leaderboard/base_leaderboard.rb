class BaseLeaderboard < ApplicationRecord
  include PolymorphicSubmitter
  belongs_to :challenge
  belongs_to :challenge_round

  as_enum :leaderboard_type,
    [:leaderboard, :ongoing, :previous, :previous_ongoing],
    map: :string
end
