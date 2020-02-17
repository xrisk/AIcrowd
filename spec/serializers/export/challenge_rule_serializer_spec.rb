require 'rails_helper'

describe Export::ChallengeRuleSerializer, serializer: true do
  subject { described_class.new(challenge_rule) }

  let(:challenge_rule) { create(:challenge_rules, terms: 'Terms') }

  describe '#as_json' do
    it 'returns serialized challenge_rule' do
      serialized_challenge_rule = subject.as_json

      expect(serialized_challenge_rule[:terms]).to include('terms')
    end
  end
end
