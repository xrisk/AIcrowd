module Discourse
  class UpdateParticipantService < ::Discourse::BaseService
    def initialize(participant:)
      @client      = prepare_http_client
      @participant = participant
    end

    def call
      with_discourse_errors_handling do
        return failure('You need to provide a participant') if participant.blank?

        response = update_user_name

        success(response)
      rescue Discourse::UnprocessableEntity => e
        return failure(e.message) if e.message.include?('is already a member of this group')

        raise e
      end
    end

    private

    attr_reader :client, :participant

    def update_user_name
      client.put(
        "/users/#{participant.name}.json", {
          name: participant.name
        }
      )
    end
  end
end
