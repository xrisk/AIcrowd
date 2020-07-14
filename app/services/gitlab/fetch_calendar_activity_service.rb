module Gitlab
  class FetchCalendarActivityService < ::Gitlab::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_gitlab_errors_handling do
        response = client.get(endpoint_path)

        activity_data = response.body.transform_keys { |key| Date.parse(key) }

        success(activity_data)
      end
    end

    private

    attr_reader :client, :participant

    def endpoint_path
      "users/#{participant.name}/calendar.json"
    end
  end
end
