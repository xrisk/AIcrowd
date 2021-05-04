module Challenges
  class DiscussionsController < ApplicationController
    include Concerns::ChallengeMasthead
    challenge_masthead_actions [:show]
    before_action :redirect_if_hidden, only: [:show]

    def show
      @discourse_topics_fetch = Rails.cache.fetch("discourse-challenge-posts/#{@challenge.id}/#{params[:page].to_i}", expires_in: 5.minutes) do
        Discourse::FetchChallengeTopicsService.new(challenge: @challenge, page: params[:page].to_i).call
      end
      @discourse_topics = @discourse_topics_fetch.value
    end

    def redirect_if_hidden
      redirect_to @challenge, notice: "You're not authorized to view this page" unless @challenge.discussions_visible?
    end
  end
end
