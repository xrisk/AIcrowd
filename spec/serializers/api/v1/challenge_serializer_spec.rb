require 'rails_helper'

describe Api::V1::ChallengeSerializer, serializer: true do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge, :running, challenge: 'Title') }

  describe '#serialize' do
    it 'serializes challenge object' do
      serialized_object = subject.serialize

      expect(serialized_object[:title]).to eq 'Title'
      expect(serialized_object[:url]).to eq 'http://localhost:3000/challenges/title'
    end
  end
end
