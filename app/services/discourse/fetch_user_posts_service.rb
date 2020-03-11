module Discourse
  class FetchUserPostsService < ::Discourse::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?

      response            = client.post(user_posts_query_path)
      response_hash       = map_response_body_to_hash(response.body)
      grouped_by_category = response_hash.group_by { |post| post['category_name'] }

      success(grouped_by_category)
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("##{participant.email} - Unable to retrieve user posts - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client, :participant

    def user_posts_query_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_USERS_POSTS_QUERY_ID']}/run.json?params={\"username\": \"#{participant.name}\"}"
    end
  end
end
