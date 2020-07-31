module Discourse
  class FetchChallengeTopicsService < ::Discourse::BaseService
    def initialize(challenge:, page:)
      @client    = prepare_http_client
      @challenge = challenge
      @page      = page
    end

    def call
      with_discourse_errors_handling do
        return failure('Challenge doesn\'t have Discourse category assigned.') if challenge.discourse_category_id.blank?

        response = client.get(challenge_posts_path)

        return success([]) if response.body['topic_list']['topics'].none?

        participants    = get_participants(response.body['users'])
        category_topics = topics_with_participant(
          response.body['topic_list']['topics'],
          response.body['users'],
          participants
        )

        success(category_topics)
      end
    end

    private

    attr_reader :client, :challenge, :page

    def challenge_posts_path
      "/c/#{challenge.discourse_category_id}.json?page=#{page}"
    end
  end
end
