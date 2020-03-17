require 'rails_helper'

describe Discourse::FetchTopContributorsService, :requests_allowed do
  subject { described_class.new }

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
      let!(:participant) { create(:participant, name: 'kelleni2') }

      it 'returns success and list of user posts' do
        result = VCR.use_cassette('discourse_api/data_explorer_queries/top_contributors/success') do
          subject.call
        end

        expect(result.success?).to eq true

        response = result.value

        expect(response.size).to eq 5
        expect(response.first['username']).to eq 'kelleni2'
        expect(response.first['score']).to eq 751
        expect(response.first['participant']).to eq participant
        expect(response.first['participant'].image_url).to eq 'users/user-avatar-default.svg'
      end
    end

    context 'when discourse API is unavailable' do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_raise(Discourse::Error)
      end

      it 'returns failure' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Discourse API is unavailable.'
      end
    end
  end
end
