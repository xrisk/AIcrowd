module Challenges
  class DiscussionsController < Challenges::BaseController
    def show
      @discourse_posts_fetch = Rails.cache.fetch("discourse-challenge-posts/#{@challenge.id}", expires_in: 5.minutes) do
        Discourse::FetchChallengePostsService.new(challenge: @challenge).call
      end
      @discourse_posts = @discourse_posts_fetch.value
    end
  end
end
