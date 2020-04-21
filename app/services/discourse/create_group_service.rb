module Discourse
  class CreateGroupService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      retry_count ||= 0

      with_discourse_errors_handling do
        response = create_group_request(ensure_uniqueness: retry_count.positive?)

        challenge.update!(discourse_group_id: response.body['basic_group']['id'])

        success(response)
      rescue Discourse::UnprocessableEntity => e
        raise e if retry_count.positive?

        retry_count += 1

        retry if e.message.include?('Name has already been taken')
      end
    end

    private

    attr_reader :client, :challenge

    def create_group_request(ensure_uniqueness: false)
      client.post(
        '/admin/groups.json', {
          group: {
            name: truncated_string(challenge.slug, ensure_uniqueness, 20)
          }
        }
      )
    end
  end
end
