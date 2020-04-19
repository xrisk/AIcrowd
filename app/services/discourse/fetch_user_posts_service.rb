module Discourse
  class FetchUserPostsService < ::Discourse::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_discourse_errors_handling do
        response            = client.post(user_posts_query_path)
        response_hash       = map_response_body_to_hash(response.body)
        grouped_by_category = response_hash.group_by { |post| post['category_name'] }

        success(grouped_by_category)
      end
    end

    private

    attr_reader :client, :participant

    def user_posts_query_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_USERS_POSTS_QUERY_ID']}/run.json?params={\"username\": \"#{participant.name}\"}"
    end
  end
end
