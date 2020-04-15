require 'rails_helper'

describe Discourse::FetchUserPostsService, :requests_allowed do
  subject { described_class.new(participant: participant) }

  let(:participant) { create(:participant, name: 'piotrekpasciaktest') }

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
        result = VCR.use_cassette('discourse_api/data_explorer_queries/user_posts/success') do
          subject.call
        end

        expect(result.success?).to eq true

        response = result.value

        expect(response.size).to eq 5
        expect(response.values[0][0]['cooked']).to eq '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit 2.</p>'
      end
    end

    context 'when discourse API is unavailable' do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_raise(Discourse::Error)
      end

      it 'returns failure' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Discourse::Error'
      end
    end
  end
end
