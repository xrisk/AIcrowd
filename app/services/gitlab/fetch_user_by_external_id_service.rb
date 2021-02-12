module Gitlab
  class FetchUserByExternalIdService < ::Gitlab::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_gitlab_errors_handling do
        response  = client.get(endpoint_path)
        user_data = response.body.first

        if user_data.blank?
          response = client.post(
            new_user_endpoint_path,
            {
              email: participant.email,
              name: participant.first_name + ' ' + participant.last_name,
              username: participant.name,
              skip_confirmation: true,
              force_random_password: true,
              reset_password: true
            })

          user_data = response.body.first
          user_data = nil if user_data.first == "message"
          user_data = {'id': user_data.last} if user_data.first == "id"
        end

        return failure('User not found in Gitlab API') if user_data.blank?

        participant.update!(gitlab_id: user_data['id'])
        success(user_data)
      end
    end

    private

    attr_reader :client, :participant

    def endpoint_path
      "api/v4/users?username=#{participant.name}"
    end

    def new_user_endpoint_path
      "api/v4/users"
    end
  end
end
