module Discourse
  class FetchSearchResultsService < ::Discourse::BaseService
    def initialize(q:)
      @client = prepare_http_client
      @q      = q
    end

    def call
      with_discourse_errors_handling do
        response           = client.get(search_path)
        posts_with_topics  = merge_topics_to_posts(response.body['posts'], response.body['topics'])
        posts_with_avatars = merge_participant_to_response(posts_with_topics)

        success(posts_with_avatars)
      end
    end

    private

    attr_reader :client, :q

    def search_path
      "/search.json?q=#{q}"
    end

    def merge_topics_to_posts(discourse_posts, discourse_topics)
      discourse_posts.map do |discourse_post|
        discourse_topic = discourse_topics.find { |discourse_topic| discourse_topic['id'] == discourse_post['topic_id'] }
        discourse_post.merge(
          'topic_title' => discourse_topic['title'],
          'topic_slug'  => discourse_topic['slug'],
          'cooked'      => discourse_post['blurb']
        )
      end
    end
  end
end
