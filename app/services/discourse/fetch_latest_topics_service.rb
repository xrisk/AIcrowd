module Discourse
  class FetchLatestTopicsService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      with_discourse_errors_handling do
        response      = client.post(latest_topics_path)

        return response.body['rows']
      end
    end

    private

    attr_reader :client

    def latest_topics_path
      '/admin/plugins/explorer/queries/16/run.json'
    end
  end
end
