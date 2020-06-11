require 'rails_helper'

describe Discourse::FetchChallengeTopicsService, :requests_allowed do
  subject { described_class.new(challenge: challenge, page: 0) }

  let(:challenge) { create(:challenge, :running, discourse_category_id: 2) }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

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
  end
end
