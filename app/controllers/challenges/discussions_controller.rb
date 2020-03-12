module Challenges
  class DiscussionsController < Challenges::BaseController
    def show
      @discourse_topics_fetch = Rails.cache.fetch("discourse-challenge-posts/#{@challenge.id}", expires_in: 5.minutes) do
        Discourse::FetchChallengeTopicsService.new(challenge: @challenge).call
      end
      @discourse_topics = @discourse_topics_fetch.value
    end
  end
end
