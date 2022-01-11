module Reputation
  class SyncChallengeLeaderboardExtraJob < ApplicationJob
    queue_as :default

    def perform
      # Reputation::SyncChallengeLeaderboardExtraService.new.call
    end
  end
end
