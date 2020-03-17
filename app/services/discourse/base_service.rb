module Discourse
  class BaseService < ::BaseService
    LOGGER_URL                  = 'log/discourse_api.log'.freeze
    CATEGORY_DEFAULT_COLOR      = '49d9e9'.freeze
    CATEGORY_DEFAULT_TEXT_COLOR = 'f0fcfd'.freeze

    protected

    def prepare_http_client
      @http_client ||= Discourse::ApiClient.new.call
    end

    def truncated_string(string, ensure_uniqueness)
      if ensure_uniqueness
        "#{string.to_s.truncate(43)}-#{SecureRandom.hex(3)}"
      else
        string.to_s.truncate(50)
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
  end
end
