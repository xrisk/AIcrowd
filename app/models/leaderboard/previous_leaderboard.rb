class PreviousLeaderboard < SqlView
  self.primary_key = :id
  after_initialize :readonly!

  include PolymorphicSubmitter
end
