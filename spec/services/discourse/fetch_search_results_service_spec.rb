require 'rails_helper'

describe Discourse::FetchSearchResultsService, :requests_allowed do
  subject { described_class.new(q: q) }

  let(:q) { 'test' }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      it 'returns success and list of search results' do
        result = VCR.use_cassette('discourse_api/search/success') do
          subject.call
        end

        expect(result.success?).to eq true

        response = result.value

        expect(response.size).to eq 50

        discourse_post = response.first

        expect(response['cooked']).to eq 'text for check update user name'
        expect(response['topic_title']).to eq 'Wednessday test for test user name'
        expect(response['topic_slug']).to eq 'wednessday-test-for-test-user-name'
      end
    end
  end
end
