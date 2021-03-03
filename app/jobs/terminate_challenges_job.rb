class TerminateChallengesJob < ApplicationJob
  queue_as :default

  def perform
    TerminateChallenges.new.call
  end
end
