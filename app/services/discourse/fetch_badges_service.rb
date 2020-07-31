module Discourse
  class FetchBadgesService < ::Discourse::BaseService
    def initialize(previous_id)
      @client      = prepare_http_client
      @previous_id = previous_id
    end

    def call
      with_discourse_errors_handling do
        response      = client.post(latest_badges_path)
        response_hash = map_response_body_to_hash(response.body)
        success(response_hash)
      end
    end

    private

    attr_reader :client

    def latest_badges_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_BADGES_QUERY_ID']}/run.json?params={\"previous_id\": \"#{@previous_id}\"}"
    end
  end
end
