require 'rails_helper'

describe Export::ChallengeRoundSerializer, serializer: true do
  subject { described_class.new(challenge_round) }

  let(:challenge_round) { create(:challenge_round, score_title: 'Score Title') }

  describe '#as_json' do
    it 'returns serialized challenge_round' do
      serialized_challenge_round = subject.as_json

      expect(challenge_round[:score_title]).to eq 'Score Title'
    end
  end
end
