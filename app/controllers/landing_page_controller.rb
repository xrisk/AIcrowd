class LandingPageController < ApplicationController
  def index
    get_challenge_list_data
    get_featured_challenges
    get_featured_notebooks
    get_menu_items
    get_stat_list_data
    get_quotes
    get_discourse_data

  end

  def host
    @page_title     = "Organize"
    @challenge_call = ChallengeCall.first
  end

  # cardBadge = {
  #   cardBadge: true,
  #   badgeColor: '#44B174',
  #   challengeEndDate: '2021/10/30',
  # }

  private

  def get_challenge_list_data
    customAvatar1 = "/assets/new_logos/custom-avatar-1.png";
    customAvatar2 = "/assets/new_logos/custom-avatar-2.png";
    customAvatar3 = "/assets/new_logos/custom-avatar-3.png";
    customAvatar4 = "/assets/new_logos/custom-avatar-4.png";
    customAvatar5 = "/assets/new_logos/custom-avatar-5.png";

    @challenge_list_data = []
    challenges = Challenge
        .includes(:organizers)
        .where(private_challenge: false)
        .where(hidden_challenge: false)
        .where.not(status_cd: :draft)
        .limit(9)

    challenges.each do |challenge|
      challenge_organizers = []
      challenge.organizers.each do |organizer|
        challenge_organizers << {
          name: organizer.organizer,
          logo: organizer.image_file.url,
          link: organizer_path(organizer.id),
        }
      end

      @challenge_list_data << {
        image: challenge.image_url,
        name: challenge.challenge,
        prize: challenge.prize_misc,
        users: [
          { id: 1, image: customAvatar1, tier: 4 },
          { id: 2, image: customAvatar2, tier: 2 },
          { id: 3, image: customAvatar3, tier: 5 },
          { id: 4, image: customAvatar4, tier: 0 },
          { id: 5, image: customAvatar5, tier: 1 },
        ],
        loading: false,
        onCard: false,
        size: 'default',
        color: '#0F2F90',
        cardBadge: true,
        badgeColor: '#44B174',
        challengeEndDate: challenge.active_round.end_dttm,
        organizers: challenge_organizers
      }
    end
  end

  def get_featured_challenges
    # @challenge_1 = Challenge
    #     .includes(:organizers)
    #     .where(private_challenge: false)
    #     .where(hidden_challenge: false)
    #     .where.not(status_cd: :draft)
    #     .where(feature_challenge_1: true)
    #     .first

    # @challenge_2 = Challenge
    #     .includes(:organizers)
    #     .where(private_challenge: false)
    #     .where(hidden_challenge: false)
    #     .where.not(status_cd: :draft)
    #     .where(feature_challenge_2: true)
    #     .first

    # @challenge_3 = Challenge
    #     .includes(:organizers)
    #     .where(private_challenge: false)
    #     .where(hidden_challenge: false)
    #     .where.not(status_cd: :draft)
    #     .where(feature_challenge_3: true)
    #     .first
  end

  def get_featured_notebooks
    @notebook_card_data = {}
    # posts = Post.where(visible: true)
    #   .where.not(image_file: nil)
    #   .order(seq: :asc)
    #   .where(featured: true).limit(4)

    # posts.each do |post|
    #   @notebook_card_data << {
    #     title: post.name,
    #     description: post.tagline,
    #     lastUpdated: helpers.discourse_time_ago(post.updated_at),
    #     image: post.thumbnail,
    #     author: post.participant.name
    #   }
    # end
  end

  def get_menu_items
    @more_menu_item = [
      {
        name: 'Organize a challenge',
        link: landing_page_host_path,
      },
      {
        name: 'Our Team',
        link: team_members_path,
      },
      {
        name: 'Jobs',
        link: job_postings_path,
      }
    ]

    @community_menu_item = [
      {
        name: 'Blog',
        link: blogs_path,
      },
      {
        name: 'Forum',
        link: '/forum',
      },
      {
        name: 'Showcase',
        link: posts_path,
      }
    ]

    @challenges_menu_item = [
      {
        name: 'Ongoing Challenges',
        link: '/ongoing-challenges',
      },
      {
        name: 'Practice Problems',
        link: '/practice-problems',
      }
    ]

    @community_map = '/assets/new_logos/map.svg'
    @community_map_avatar = '/assets/new_logos/map-avatar.png'
  end

  def get_discourse_data
    @discourse_topics_fetch = Rails.cache.fetch('discourse-latest-topics', expires_in: 5.minutes) do
      Discourse::FetchLatestTopicsService.new.call
    end

    @discourse_top_contributors_fetch = Rails.cache.fetch('discourse-top-contributors', expires_in: 5.minutes) do
      Discourse::FetchTopContributorsService.new.call
    end

    @discourse_topics           = @discourse_topics_fetch.value
    @discourse_top_contributors = @discourse_top_contributors_fetch.value


    @submission_card_data = []
    @discourse_topics.each do |val|
      @submission_card_data << {
        title: val["title"],
        description: val["excerpt"], #point_down,
        comment_count: val["posts_count"],
        isComment: true,
        image: (Participant.find_by_name(val["name"]).image_file.url rescue '/assets/new_logos/custom-avatar-3.png'),
        onCard: true,
        borderColor: '#fff',
        tier: 2
      }
    end
  end

  def get_quotes
    @quotes =  {
      leaderDescription:
        '1-2 Sentences related to how these winners were selected or what does leaderboard winners mean.',
      quote: 'I love you the more in that I believe you had liked me for my own sake and for nothing else',
      author: 'John Keats',
      borderColor: 'red',
      image: '/assets/new_logos/custom-avatar-1.png',
      quotes: [
        {
          quote:
            'Crowdsourcing far exceeded our expectations - you not only get $new solutions$, but also a $deeper insight to the problem$ you are trying to $solve$.',
          author: 'John Keats',
          post: 'Postdoctoral Researcher, Stanford',
        },
        {
          quote: "I have not failed. I've just found 10,000 ways that won't work.",
          author: 'Thomas A. Edison',
          post: 'Postdoctoral Researcher, Stanford',
        },
        {
          quote: 'But man is not made for defeat. A man can be destroyed but not defeated.',
          author: 'Ernest Hemingway',
          post: 'Postdoctoral Researcher, Stanford',
        },
        {
          quote:
            'The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.',
          author: 'Albert Einstein',
          post: 'Postdoctoral Researcher, Stanford',
        },
        {
          quote: 'The person, be it gentleman or lady, who has not pleasure in a good novel, must be intolerably stupid.',
          author: 'Jane Austen',
          post: 'Postdoctoral Researcher, Stanford',
        },
      ],
    }
  end

  def get_stat_list_data
    @stat_list_data = [
        {
          count: 80,
          statText: 'Completed Challenges',
        },
        {
          count: '25k',
          statText: 'Community Members',
        },
        {
          count: '$250k',
          statText: 'Awarded in Prizes',
        },
        {
          count: '60',
          statText: 'Research Papers',
        },
        {
          count: '12 TB',
          statText: 'Codes, Models & Datasets',
        },
      ]
  end

end
