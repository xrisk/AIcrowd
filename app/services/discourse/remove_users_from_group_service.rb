module Discourse
  class RemoveUsersFromGroupService < ::Discourse::BaseService
    def initialize(challenge:, usernames:)
      @client    = prepare_http_client
      @challenge = challenge
      @usernames = usernames
    end

    def call
      with_discourse_errors_handling do
        return failure('Discourse group doesn\'t exist in our database') if challenge.discourse_group_id.blank?
        return failure('You need to provide at least one participant') if usernames.blank?

        response = remove_users_from_group_request

        success(response)
      rescue Discourse::BadRequest => e
        discourse_logger.error(e.message)
        # This happens when username is not part of the group
        return failure(e.message) if e.message.include?('You supplied invalid parameters to the request: Discourse::InvalidParameters')
        # This happens when username doesn't exist in Discourse database
        return failure(e.message) if e.message.include?('You supplied invalid parameters to the request: usernames')

        raise e
      end
    end

    private

    attr_reader :client, :challenge, :usernames

    def remove_users_from_group_request
      client.delete(
        "/groups/#{challenge.discourse_group_id}/members.json", {
          usernames: usernames
        }
      )
    end
  end
end
