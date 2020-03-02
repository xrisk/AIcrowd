class LandingPageController < ApplicationController
  before_action :terminate_challenge, only: [:index]

  def index
    @challenges = Challenge
                      .includes(:organizers)
                      .where(private_challenge: false)
                      .where(hidden_challenge: false)
                      .where.not(status_cd: :draft)
                      .limit(6)
    @partners = Partner
                    .where(visible: true)
                    .where.not(image_file: nil)
                    .order(seq: :asc)
                    .limit(8)
    @blog_posts = Blog
                      .where(published: true)
                      .order(seq: :asc)
                      .limit(4)

    @discourse_topics_fetch = Rails.cache.fetch('discourse-latest-topics', expires_in: 5.minutes) do
      Discourse::FetchLatestTopicsService.new.call
    end
    @discourse_top_contributors_fetch = Rails.cache.fetch('discourse-top-contributors', expires_in: 5.minutes) do
      Discourse::FetchTopContributorsService.new.call
    end
    @discourse_topics           = @discourse_topics_fetch.value
    @discourse_top_contributors = @discourse_top_contributors_fetch.value
    
    @participants = ParticipantRatingRanksQuery.new.participants_with_ranks.limit 5
  end

  def host
    @page_title     = "Organize"
    @challenge_call = ChallengeCall.first
  end
end
