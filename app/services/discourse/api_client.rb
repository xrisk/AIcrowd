module Discourse
  class Error < StandardError; end
  class UnauthenticatedError < StandardError; end
  class NotFoundError < StandardError; end
  class UnprocessableEntity < StandardError; end
  class TooManyRequests < StandardError; end

  class HandleErrorsMiddleware < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
      when 403
        raise Discourse::UnauthenticatedError.new(env.body)
      when 404, 410
        raise Discourse::NotFoundError.new(env.body)
      when 422
        raise Discourse::UnprocessableEntity.new(env.body)
      when 429
        raise Discourse::TooManyRequests.new(env.body)
      when 500...600
        raise Discourse::Error.new(env.body)
      end
    end
  end

  class ParseJsonMiddleware < Faraday::Response::Middleware
    def on_complete(env)
      env[:body] = ::JSON.parse(env.body)
    rescue JSON::ParserError => e
      raise Discourse::Error.new(e.message)
    end
  end

  class ApiClient
    def call
      return if ENV['DISCOURSE_DOMAIN_NAME'].blank? ||
        ENV['DISCOURSE_API_KEY'].blank? ||
        ENV['DISCOURSE_API_USERNAME'].blank?

      Faraday.new(http_client_options) do |http_client|
        http_client.request :url_encoded
        http_client.use     Discourse::HandleErrorsMiddleware
        http_client.use     Discourse::ParseJsonMiddleware
        http_client.adapter Faraday.default_adapter
      end
    end

    private

    def http_client_options
      {
        url: ENV['DISCOURSE_DOMAIN_NAME'],
        headers: {
          accept: 'application/json',
          'Api-Key'      => ENV['DISCOURSE_API_KEY'],
          'Api-Username' => ENV['DISCOURSE_API_USERNAME']
        }
      }
    end
  end
end
