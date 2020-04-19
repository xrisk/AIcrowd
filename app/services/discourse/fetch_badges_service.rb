module Discourse
  class FetchBadgesService < ::Discourse::BaseService
    def initialize(previous_id)
      @client = prepare_http_client
      @previous_id = previous_id
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?

      response      = client.post(latest_badges_path)
      response_hash         = map_response_body_to_hash(response.body)
      success(response_hash)
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("Unable to retrieve latest badges - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client

    def latest_badges_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_BADGES_QUERY_ID']}/run.json?params={\"previous_id\": \"#{@previous_id}\"}"
    end
  end
end
