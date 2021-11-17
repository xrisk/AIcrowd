module Discourse
  class FetchTopContributorsService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      with_discourse_errors_handling do
        response              = client.post(challenge_posts_path)
        response_hash         = map_response_body_to_hash(response.body)
        response_with_avatars = merge_participant_to_response(response_hash)

        success(response_with_avatars.take(4))
      end
    end

    private

    attr_reader :client

    def challenge_posts_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_TOP_CONTRIBUTORS_QUERY_ID']}/run.json"
    end
  end
end
