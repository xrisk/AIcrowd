require 'rails_helper'

describe Api::V1::ChallengeRoundSerializer, serializer: true do
  subject { described_class.new(challenge_round: challenge_round) }

  let(:challenge_round) { create(:challenge_round, challenge_round: 'Title') }

  describe '#serialize' do
    it 'serializes challenge object' do
      serialized_object = subject.serialize

      expect(serialized_object[:challenge_round]).to eq 'Title'
    end
  end
end
