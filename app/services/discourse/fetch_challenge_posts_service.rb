module Discourse
  class FetchChallengePostsService < ::Discourse::BaseService
    def initialize(challenge:)
      @client    = prepare_http_client
      @challenge = challenge
    end

    def call
      return failure('Discourse API client couldn\'t be properly initialized.') if client.nil?
      return failure('Challenge doesn\'t have Discourse category assigned.') if challenge.discourse_category_id.blank?

      response              = client.post(challenge_posts_path)
      response_hash         = map_response_body_to_hash(response.body)
      response_with_avatars = merge_avatar_url_to_response(response_hash)

      success(response_with_avatars)
    rescue Discourse::Error => e
      Logger.new(::Discourse::BaseService::LOGGER_URL).error("##{challenge.challenge} - Unable to retrieve challenge posts - #{e.message}")

      failure('Discourse API is unavailable.')
    end

    private

    attr_reader :client, :challenge

    def challenge_posts_path
      "/admin/plugins/explorer/queries/#{ENV['DISCOURSE_API_CHALLENGE_POSTS_QUERY_ID']}/run.json?params={\"category_id\": \"#{challenge.discourse_category_id}\"}"
    end

    def merge_avatar_url_to_response(response_hash)
      usernames             = response_hash.map { |row| row['username'] }.uniq
      participants          = Participant.where(name: usernames)

      response_hash.map { |row| row.merge('avatar_url' => avatar_url_by_username(participants, row['username'])) }
    end

    def avatar_url_by_username(participants, username)
      participants.find { |participant| participant.name == username}&.image_url || ImageUploader.new.default_url
    end
  end
end
