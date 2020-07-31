module Discourse
  class AddUsersToGroupService < ::Discourse::BaseService
    def initialize(challenge:, participants:)
      @client       = prepare_http_client
      @challenge    = challenge
      @participants = participants
    end

    def call
      with_discourse_errors_handling do
        return failure('Discourse group doesn\'t exist in our database') if challenge.discourse_group_id.blank?
        return failure('You need to provide at least one participant') if participants.blank?

        response = add_users_to_group_request

        success(response)
      rescue Discourse::UnprocessableEntity => e
        return failure(e.message) if e.message.include?('is already a member of this group')
        return failure(e.message) if e.message.include?('are already members of this group')

        raise e
      rescue Discourse::BadRequest => e
        discourse_logger.error(e.message)
        # This happens when username doesn't exist in Discourse database
        return failure(e.message) if e.message.include?('You supplied invalid parameters to the request: usernames')

        raise e
      end
    end

    private

    attr_reader :client, :challenge, :participants

    def add_users_to_group_request
      client.put(
        "/groups/#{challenge.discourse_group_id}/members.json", {
          usernames: participants_usernames
        }
      )
    end

    def participants_usernames
      participants.pluck(:name).join(',')
    end
  end
end
