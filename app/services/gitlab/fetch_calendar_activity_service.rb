module Gitlab
  class FetchCalendarActivityService < ::BaseService
    LOGGER_URL = 'log/gitlab_api.log'.freeze

    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      response = client.get(endpoint_path)

      if response.status == 200
        parsed_data   = JSON.parse(response.body)
        activity_data = parsed_data.transform_keys { |key| Date.parse(key) }

        success(activity_data)
      else
        error_message = JSON.parse(response.body)['error']

        gitlab_logger.error(error_message)
        failure(error_message)
      end
    rescue ::Faraday::Error, ::JSON::ParserError => e
      gitlab_logger.error(e.message)
      failure(e.message)
    end

    private

    attr_reader :client, :participant

    def endpoint_path
      "users/#{participant.name}/calendar.json"
    end

    def prepare_http_client
      Faraday.new(http_client_options) do |http_client|
        http_client.request :url_encoded
        http_client.adapter Faraday.default_adapter
      end
    end

    def http_client_options
      {
        url: 'https://gitlab.aicrowd.com/',
        headers: {
          accept: 'application/json'
        }
      }
    end

    def gitlab_logger
      Logger.new(LOGGER_URL)
    end
  end
end
