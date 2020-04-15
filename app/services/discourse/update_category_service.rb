module Discourse
  class UpdateCategoryService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      retry_count ||= 0

      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?
      return failure('Discourse category doesn\'t exist in our database.') if challenge.discourse_category_id.blank?

      with_discourse_errors_handling do
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
        "/categories/#{challenge.discourse_category_id}.json", {
          name:       truncated_string(challenge.challenge, ensure_uniqueness),
          color:      ::Discourse::BaseService::CATEGORY_DEFAULT_COLOR,
          text_color: ::Discourse::BaseService::CATEGORY_DEFAULT_TEXT_COLOR
        }
      )
    end
  end
end
