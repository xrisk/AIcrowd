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

    def merge_avatar_url_to_response(response_hash)
      usernames    = response_hash.map { |row| row['username'] }.uniq
      participants = Participant.where(name: usernames)

      response_hash.map { |row| row.merge('avatar_url' => avatar_url_by_username(participants, row['username'])) }
    end

    def avatar_url_by_username(participants, username)
      participants.find { |participant| participant.name == username}&.image_url || ImageUploader.new.default_url
    end
  end
end
