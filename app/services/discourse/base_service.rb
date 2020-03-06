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
  end
end
