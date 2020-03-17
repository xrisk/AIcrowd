module Discourse
  class FetchLatestTopicsService < ::Discourse::BaseService
    def initialize
      @client = prepare_http_client
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?

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
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("Unable to retrieve latest topics - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client

    def latest_topics_path
      '/latest.json'
    end
  end
end
