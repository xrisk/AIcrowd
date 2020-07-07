module Gitlab
  class BaseService < ::BaseService
    LOGGER_URL = 'log/gitlab_api.log'.freeze

    protected

    def prepare_http_client
      Gitlab::ApiClient.new.call
    end

    def with_gitlab_errors_handling(&block)
      return failure('Gitlab API client couldn\'t be properly initialized.') if client.nil?

      block.call
    rescue Gitlab::Error, Gitlab::UnauthenticatedError, Gitlab::NotFoundError => e
      gitlab_logger.error(e.message)
      failure(e.message)
    end

    def gitlab_logger
      @logger ||= Logger.new(LOGGER_URL)
    end
  end
end
