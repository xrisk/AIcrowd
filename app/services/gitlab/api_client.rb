module Gitlab
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
        raise Gitlab::BadRequest, env.body
      when 401, 403
        raise Gitlab::UnauthenticatedError, env.body
      when 404, 410
        raise Gitlab::NotFoundError, env.body
      when 422
        raise Gitlab::UnprocessableEntity, env.body
      when 429
        raise Gitlab::TooManyRequests, env.body
      when 500...600
        raise Gitlab::Error, env.body
      end
    end
  end

  class ParseJsonMiddleware < Faraday::Response::Middleware
    def on_complete(env)
      env[:body] = ::JSON.parse(env.body)
    rescue JSON::ParserError => e
      raise Gitlab::Error, e.message
    end
  end

  class ApiClient
    def call
      return if ENV['GITLAB_API_KEY'].blank?

      Faraday.new(http_client_options) do |http_client|
        http_client.request :url_encoded
        http_client.use     Gitlab::HandleErrorsMiddleware
        http_client.use     Gitlab::ParseJsonMiddleware
        http_client.use     FaradayMiddleware::FollowRedirects, limit: 5
        http_client.adapter Faraday.default_adapter
      end
    end

    private

    def http_client_options
      {
        url:     'https://gitlab.aicrowd.com/',
        headers: {
          :accept         => 'application/json',
          'Private-Token' => ENV['GITLAB_API_KEY']
        }
      }
    end
  end
end
