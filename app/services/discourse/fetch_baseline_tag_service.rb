module Discourse
  class FetchBaselineTagService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      with_discourse_errors_handling do
        return failure('Challenge doesn\'t have Discourse category assigned.') if challenge.discourse_category_id.blank?

        response = client.get(user_posts_query_path)
        topics   = response.body['topic_list']['topics']

        success(topics)
      end
    end

    private

    attr_reader :client, :challenge

    def user_posts_query_path
      "tags/c/#{challenge.slug}/#{challenge.discourse_category_id}/baseline.json"
    end
  end
end
