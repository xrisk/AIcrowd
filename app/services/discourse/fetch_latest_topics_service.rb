module Discourse
  class FetchLatestTopicsService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      with_discourse_errors_handling do
        response      = client.get(latest_topics_path)
        participants  = get_participants(response.body['users'])
        latest_topics = topics_with_participant(
          response.body['topic_list']['topics'],
          response.body['users'],
          participants
        )

        # Remove Welcome to Discourse topic if it gets inserted as first element
        latest_topics.shift if latest_topics.first['title'] == 'Welcome to Discourse'

        success(latest_topics.take(4))
      end
    end

    private

    attr_reader :client

    def latest_topics_path
      '/latest.json'
    end
  end
end
