module Discourse
  class FetchChallengeTopicsService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?
      return failure('Challenge doesn\'t have Discourse category assigned.') if challenge.discourse_category_id.blank?

      with_discourse_errors_handling do
        response        = client.get(challenge_posts_path)
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

    attr_reader :client, :challenge

    def challenge_posts_path
      "/c/#{challenge.discourse_category_id}.json"
    end
  end
end
