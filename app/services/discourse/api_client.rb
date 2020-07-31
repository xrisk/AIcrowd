module Discourse
  class Error < StandardError; end
  class BadRequest < StandardError; end
  class UnauthenticatedError < StandardError; end
  class NotFoundError < StandardError; end
  class UnprocessableEntity < StandardError; end
  class TooManyRequests < StandardError; end

  class HandleErrorsMiddleware < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
      when 400
        raise Discourse::BadRequest, env.body
      when 403
        raise Discourse::UnauthenticatedError, env.body
      when 404, 410
        raise Discourse::NotFoundError, env.body
      when 422
        raise Discourse::UnprocessableEntity, env.body
      when 429
        raise Discourse::TooManyRequests, env.body
      when 500...600
        raise Discourse::Error, env.body
      end
    end
  end

  class ParseJsonMiddleware < Faraday::Response::Middleware
    def on_complete(env)
      env[:body] = ::JSON.parse(env.body)
    rescue JSON::ParserError => e
      raise Discourse::Error, e.message
    end
  end

  class ApiClient
    def initialize(api_username: nil)
      @api_username = api_username || ENV['DISCOURSE_API_USERNAME']
    end

    def call
      return if ENV['DISCOURSE_DOMAIN_NAME'].blank? ||
                ENV['DISCOURSE_API_KEY'].blank? ||
                api_username.blank?

      Faraday.new(http_client_options) do |http_client|
        http_client.request :url_encoded
        http_client.use     Discourse::HandleErrorsMiddleware
        http_client.use     Discourse::ParseJsonMiddleware
        http_client.adapter Faraday.default_adapter
      end
    end

    private

    attr_reader :api_username

    def http_client_options
      {
        url:     ENV['DISCOURSE_DOMAIN_NAME'],
        headers: {
          :accept        => 'application/json',
          'Api-Key'      => ENV['DISCOURSE_API_KEY'],
          'Api-Username' => api_username
        }
      }
    end
  end
end
