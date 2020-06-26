module Discourse
  class UpsertUserService < ::Discourse::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_discourse_errors_handling do
        update_user_request

        success
      end
    end

    private

    attr_reader :client, :participant

    def update_user_request
      request_payload.to_query

      client.post(
        'admin/users/sync_sso', request_payload
      )
    end

    def request_payload
      encoded_response_query = Base64.strict_encode64(participant_params.to_query)
      request_signature      = OpenSSL::HMAC.hexdigest('sha256', ENV['SSO_SECRET'], encoded_response_query)

      {
        sso: CGI.escape(encoded_response_query),
        sig: request_signature
      }
    end

    def participant_params
      {
        name:        participant.name,
        username:    participant.name,
        email:       participant.email,
        external_id: participant.id
      }
    end
  end
end
