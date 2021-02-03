module Gitlab
  class FetchUserByExternalIdService < ::Gitlab::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_gitlab_errors_handling do
        response  = client.get(endpoint_path)
        try
          user_data = response.body.first
        rescue Gitlab::NotFoundError => e
          response = client.post(
            new_user_endpoint_path,
            {
              email: participant.email,
              name: participant.first_name + ' ' + participant.last_name,
              username: participant.name,
              skip_confirmation: true
            })
          user_data = response.body.first
        end

        return failure('User not found in Gitlab API') if user_data.blank?

        participant.update!(gitlab_id: user_data['id'])
        success(user_data)
      end
    end

    private

    attr_reader :client, :participant

    def endpoint_path
      "api/v4/users?extern_uid=#{participant.id}&provider=oauth2_generic"
    end

    def new_user_endpoint_path
      "api/v4/users&provider=oauth2_generic"
    end
  end
end
