module Discourse
  class UpdateCategoryService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      retry_count ||= 0

      with_discourse_errors_handling do
        return failure('Discourse category doesn\'t exist in our database.') if challenge.discourse_category_id.blank?

        update_category_request(ensure_uniqueness: retry_count.positive?)

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

    def update_category_request(ensure_uniqueness: false)
      # Discouse API has following validations that we need to comply with:
      # - category name cannot be longer then 50 signs
      # - category name has to be unique
      # - slug has to be unique
      client.put(
        "/categories/#{challenge.discourse_category_id}.json", category_request_payload(ensure_uniqueness)
      )
    end

    def category_request_payload(ensure_uniqueness)
      payload = {
        name:       truncated_string(challenge.challenge, ensure_uniqueness),
        color:      ::Discourse::BaseService::CATEGORY_DEFAULT_COLOR,
        text_color: ::Discourse::BaseService::CATEGORY_DEFAULT_TEXT_COLOR
      }

      payload.merge!(permissions: discourse_permissions) if challenge.discourse_group_name.present?

      payload
    end

    def discourse_permissions
      if challenge.hidden_in_discourse?
        {
          challenge.discourse_group_name => ::Discourse::BaseService::DEFAULT_GROUP_PERMISSIONS
        }
      else
        {
          ::Discourse::BaseService::DEFAULT_GROUP_NAME => ::Discourse::BaseService::DEFAULT_GROUP_PERMISSIONS
        }
      end
    end
  end
end
