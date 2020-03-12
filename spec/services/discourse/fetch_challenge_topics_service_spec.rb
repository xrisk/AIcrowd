require 'rails_helper'

describe Discourse::FetchChallengeTopicsService, :requests_allowed do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge, :running, discourse_category_id: 2) }

  describe '#call' do
    context 'when discourse ENV variables are missing' do
      before { ENV.stub(:[]).with('DISCOURSE_DOMAIN_NAME').and_return('') }

      it 'returns failure' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Discourse API client couldn\'t be properly initialized.'
      end
    end

    context 'when discourse ENV variables are set' do
      it 'returns success and list of user posts' do
        result = VCR.use_cassette('discourse_api/challenge_topics/success') do
          subject.call
        end

        expect(result.success?).to eq true

        response = result.value

        expect(response.size).to eq 2
        expect(response.first['title']).to eq 'Welcome to the Lounge'
      end
    end

    context 'when discourse API is unavailable' do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Discourse::Error)
      end

      it 'returns failure' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Discourse API is unavailable.'
      end
    end
  end
end
