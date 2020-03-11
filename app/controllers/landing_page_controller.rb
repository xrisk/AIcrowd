class LandingPageController < ApplicationController
  before_action :terminate_challenge, only: [:index]
  before_action :set_filters, only: [:index]

  respond_to :html, :js

  def index
    @challenges = ChallengeFilterService.new(params).filter_challenge
    @challenges = @challenges
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
    @participants = Participant
                        .reorder(created_at: :desc)
                        .limit(5)

    @discourse_topics_fetch = Rails.cache.fetch('discourse-latest-topics', expires_in: 5.minutes) do
      Discourse::FetchLatestTopicsService.new.call
    end
    @discourse_top_contributors_fetch = Rails.cache.fetch('discourse-top-contributors', expires_in: 5.minutes) do
      Discourse::FetchTopContributorsService.new.call
    end
    @discourse_topics           = @discourse_topics_fetch.value
    @discourse_top_contributors = @discourse_top_contributors_fetch.value
  end

  def host
    @page_title     = "Organize"
    @challenge_call = ChallengeCall.first
  end

  private

  def set_filters
    @categories = Category.all
    @status     = challenge_status
    @prize_hash = { prize_cash:     'Cash prizes',
                    prize_travel:   'Travel grants',
                    prize_academic: 'Academic papers',
                    prize_misc:     'Misc prizes' }
  end

  def challenge_status
    params[:controller].eql?("landing_page") ? Challenge.statuses.keys - ['draft'] : Challenge.statuses.keys
  end
end
