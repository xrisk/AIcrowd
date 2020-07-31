module Gitlab
  class UpdateUsernameService < ::Gitlab::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_gitlab_errors_handling do
        gitlab_id = fetch_gitlab_id

        return failure('Unable to to retrieve participant.gitlab_id from Gitlab API') if gitlab_id.blank?

        response = client.put(endpoint_path(gitlab_id), request_payload)

        success(response.body)
      end
    end

    private

    attr_reader :client, :participant

    def endpoint_path(gitlab_id)
      "api/v4/users/#{gitlab_id}"
    end

    def request_payload
      {
        name:     participant.name,
        username: participant.name
      }
    end

    def fetch_gitlab_id
      return participant.gitlab_id if participant.gitlab_id.present?

      result = Gitlab::FetchUserByExternalIdService.new(participant: participant).call

      result.value['id'] if result.success?
    end
  end
end
