module Discourse
  class CreateCategoryService < ::Discourse::BaseService
    def initialize(challenge:)
      api_username = challenge.organizers.first&.participants&.first&.name
      @client      = prepare_http_client(api_username: api_username)
      @challenge   = challenge
    end

    def call
      retry_count ||= 0

      with_discourse_errors_handling do
        response = create_category_request(ensure_uniqueness: retry_count.positive?)
        challenge.update!(discourse_category_id: response.body['category']['id'])
        response = create_topic_request(dscourse_category_id: response.body['category']['id'])

        success
      rescue Discourse::UnprocessableEntity => e
        raise e if retry_count >= 2

        retry_count += 1

        retry if e.message.include?('Category Name has already been taken')
        retry if e.message.include?('Slug is already in use')
      rescue Discourse::UnauthenticatedError => e
        raise e if retry_count >= 2

        retry_count += 1

        @client = prepare_http_client

        response = create_category_request(ensure_uniqueness: retry_count.positive?)
        challenge.update!(discourse_category_id: response.body['category']['id'])

        success
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

    def create_topic_request discourse_category_id
      client.post(
        '/posts.json', topic_request_payload
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

    def topic_request_payload
      {
        title: "Welcome to the #{@challenge.challenge}!",
        category: discourse_category_id
        raw: "Body: Hi! This is the welcome thread for the <challenge name>, where all the participants of the challenge get to know each other.
              You can reply to this thread with a brief introduction of you and what brings you to this challenge, and get the ball rolling :sparkles:
              ---
              Some important links:
              :memo: Community Contributed Notebooks: <>
              :muscle:  Challenge Page: <>
              :trophy:  Leaderboard: <>
              All the best!
              Team AIcrowd"
      }
    end
  end
end
