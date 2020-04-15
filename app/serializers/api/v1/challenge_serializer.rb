module Api
  module V1
    class ChallengeSerializer
      def initialize(challenge:)
        @challenge = challenge
      end

      def serialize
        {
          id:    challenge.id,
          slug:  challenge.slug,
          title: challenge.challenge,
          url:   Rails.application.routes.url_helpers.challenge_url(challenge)
        }
      end

      private

      attr_reader :challenge
    end
  end
end
