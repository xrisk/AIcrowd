class LandingPageController < ApplicationController
  def index
    @challenges = Rails.cache.fetch('landing-page-challenges', expires_in: 5.minutes) do
      Challenge
        .includes(:organizers)
        .where(private_challenge: false)
        .where(hidden_challenge: false)
        .where.not(status_cd: :draft)
        .limit(9)
    end

    @partners = Rails.cache.fetch('landing-page-partners', expires_in: 5.minutes) do
      Partner
        .where(visible: true)
        .where.not(image_file: nil)
        .order(seq: :asc)
        .limit(8)
    end

    @blog_posts = Rails.cache.fetch('landing-page-blogs', expires_in: 5.minutes) do
      Blog
        .where(published: true)
        .order(seq: :asc)
        .limit(3)
    end

    @discourse_topics_fetch = Rails.cache.fetch('discourse-latest-topics', expires_in: 5.minutes) do
      Discourse::FetchLatestTopicsService.new.call
    end
    @discourse_top_contributors_fetch = Rails.cache.fetch('discourse-top-contributors', expires_in: 5.minutes) do
      Discourse::FetchTopContributorsService.new.call
    end

    @top_posts = Rails.cache.fetch('top-posts', expires_in: 5.minutes) do
      @posts = Post.order(:created_at).all.limit(4)
    end

    @discourse_topics           = @discourse_topics_fetch.value
    @discourse_top_contributors = @discourse_top_contributors_fetch.value
    
    # TODO: Migrate all the rating related code at one place, so we don't need to 
    # change the whole codebase for future changes.
    @participants = Rails.cache.fetch('top5-participants-by-ranking', expires_in: 5.minutes) do
      Participant.where("ranking > 0").reorder(:ranking).limit(5)
    end

    @social_mage_image = Rails.cache.fetch('home-page-social-image', expires_in: 5.minutes) do
      if Setting.first.home_page_social_image?
        meta_image = Setting.first.home_page_social_image.url
      end
    emd
  end

  def host
    @page_title     = "Organize"
    @challenge_call = ChallengeCall.first
  end
end
