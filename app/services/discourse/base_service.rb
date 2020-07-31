module Discourse
  class BaseService < ::BaseService
    LOGGER_URL                  = 'log/discourse_api.log'.freeze
    CATEGORY_DEFAULT_COLOR      = '49d9e9'.freeze
    CATEGORY_DEFAULT_TEXT_COLOR = 'f0fcfd'.freeze
    DEFAULT_GROUP_PERMISSIONS   = 1
    DEFAULT_GROUP_NAME          = 'everyone'.freeze

    protected

    def prepare_http_client(api_username: nil)
      Discourse::ApiClient.new(api_username: api_username).call
    end

    def truncated_string(string, ensure_uniqueness, string_length = 50)
      if ensure_uniqueness
        "#{string.to_s.first(string_length - 7)}-#{SecureRandom.hex(3)}"
      else
        string.to_s.first(string_length)
      end
    end

    def map_response_body_to_hash(response_body)
      response_body['rows'].map { |response_row| response_body['columns'].zip(response_row).to_h }
    end

    def merge_participant_to_response(response_hash)
      participants = get_participants(response_hash)

      response_hash.map { |row| row.merge('participant' => participant_by_username(participants, row['username'])) }
    end

    def participant_by_username(participants, username)
      participants.find { |participant| participant.name == username }
    end

    def get_participants(discourse_users)
      usernames = discourse_users.map { |discourse_user| discourse_user['username'] }.uniq

      Participant.where(name: usernames)
    end

    def topics_with_participant(topics, discourse_users, participants)
      topics.each do |topic|
        topic['posters'].each do |poster|
          discourse_user        = discourse_users.find { |discourse_user| discourse_user['id'] == poster['user_id'] }
          poster['participant'] = participant_by_username(participants, discourse_user['username'])
        end
      end
    end

    def with_discourse_errors_handling(&block)
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?

      block.call
    rescue Discourse::Error, Discourse::UnauthenticatedError, Discourse::NotFoundError => e
      discourse_logger.error(e.message)
      failure(e.message)
    rescue Discourse::TooManyRequests => e
      discourse_logger.error(e.message)
      Rollbar.warning(e)
      failure(e.message)
    end

    def discourse_logger
      @logger ||= Logger.new(::Discourse::BaseService::LOGGER_URL)
    end
  end
end
