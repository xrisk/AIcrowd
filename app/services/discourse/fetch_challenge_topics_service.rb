module Discourse
  class FetchChallengeTopicsService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?
      return failure('Challenge doesn\'t have Discourse category assigned.') if challenge.discourse_category_id.blank?

      response              = client.get(challenge_posts_path)
      category_participants = category_participants(response.body['users'])
      category_topics       = category_topics_with_avatar_url(
                                response.body['topic_list']['topics'],
                                response.body['users'],
                                category_participants
                              )

      success(category_topics)
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("##{challenge.challenge} - Unable to retrieve challenge posts - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client, :challenge

    def challenge_posts_path
      "/c/#{challenge.discourse_category_id}.json"
    end

    def category_participants(category_users)
      category_usernames = category_users.map { |category_user| category_user['username'] }

      Participant.where(name: category_usernames)
    end

    def category_topics_with_avatar_url(category_topics, category_users, category_participants)
      category_topics.each do |topic|
        topic['posters'].each do |poster|
          category_user        = category_users.find { |category_user| category_user['id'] == poster['user_id'] }
          poster['username']   = category_user['username']
          poster['avatar_url'] = avatar_url_by_username(category_participants, category_user['username'])
        end
      end
    end
  end
end
