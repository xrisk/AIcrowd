module Discourse
  class CreateCategoryService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      retry_count ||= 0

      with_discourse_errors_handling do
        response = create_category_request(ensure_uniqueness: retry_count.positive?)

        challenge.update!(discourse_category_id: response.body['category']['id'])

        success
      rescue Discourse::UnprocessableEntity => e
        raise e if retry_count.positive?

        retry_count += 1

        retry if e.message.include?('Category Name has already been taken')
        retry if e.message.include?('Slug is already in use')
      end
    end

    private

    attr_reader :client, :challenge

    def create_category_request(ensure_uniqueness: false)
      # Discouse API has following validations that we need to comply with:
      # - category name cannot be longer then 50 signs
      # - category name has to be unique
      # - slug has to be unique
      client.post(
        '/categories.json', category_request_payload(ensure_uniqueness)
      )
    end

    def category_request_payload(ensure_uniqueness)
      payload = {
        name:       truncated_string(challenge.challenge, ensure_uniqueness),
        color:      ::Discourse::BaseService::CATEGORY_DEFAULT_COLOR,
        text_color: ::Discourse::BaseService::CATEGORY_DEFAULT_TEXT_COLOR
      }

      if challenge.discourse_group_name.present?
        payload.merge!(
          permissions: {
            challenge.discourse_group_name => ::Discourse::BaseService::DEFAULT_GROUP_PERMISSIONS
          }
        )
      end

      payload
    end
  end
end
