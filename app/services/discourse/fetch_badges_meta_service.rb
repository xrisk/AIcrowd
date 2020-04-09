module Discourse
  class FetchBadgesMetaService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?

      response      = client.post(badges_meta_path)
      puts response
      response_hash         = map_response_body_to_hash(response.body)
      success(response_hash)
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("Unable to retrieve latest topics - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client

    def badges_meta_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_BADGES_META_QUERY_ID']}/run.json"
    end
  end
end
