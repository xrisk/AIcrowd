module Discourse
  class FetchBadgesMetaService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      with_discourse_errors_handling do
        response      = client.post(badges_meta_path)
        response_hash = map_response_body_to_hash(response.body)
        success(response_hash)
      end
    end

    private

    attr_reader :client

    def badges_meta_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_BADGES_META_QUERY_ID']}/run.json"
    end
  end
end
