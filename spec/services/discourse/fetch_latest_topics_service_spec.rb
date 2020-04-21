require 'rails_helper'

describe Discourse::FetchLatestTopicsService, :requests_allowed do
  subject { described_class.new }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      it 'returns success and list of user posts' do
        result = VCR.use_cassette('discourse_api/latest_topics/success') do
          subject.call
        end

        expect(result.success?).to eq true

        response = result.value

        expect(response.size).to eq 4
        expect(response.first['title']).to eq 'Random post for testing x2 - Shivam'
      end
    end
  end
end
