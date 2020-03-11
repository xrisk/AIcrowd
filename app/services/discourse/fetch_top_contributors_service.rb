module Discourse
  class FetchTopContributorsService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?
      return failure('DISCOURSE_API_TOP_CONTRIBUTORS_QUERY_ID ENV variable is missing.') if ENV['DISCOURSE_API_TOP_CONTRIBUTORS_QUERY_ID'].blank?

      response              = client.post(challenge_posts_path)
      response_hash         = map_response_body_to_hash(response.body)
      response_with_avatars = merge_avatar_url_to_response(response_hash)

      success(response_with_avatars.take(5))
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("Unable to retrieve top contributors - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client

    def challenge_posts_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_TOP_CONTRIBUTORS_QUERY_ID']}/run.json"
    end
  end
end
