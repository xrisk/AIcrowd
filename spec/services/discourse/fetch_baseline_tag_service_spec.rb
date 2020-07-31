require 'rails_helper'

describe Discourse::FetchBaselineTagService, :requests_allowed do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge, :running, challenge: 'Short Challenge Name', discourse_category_id: 1) }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      it 'returns success and list of baseline tags' do
        result = VCR.use_cassette('discourse_api/baseline_tag/success') do
          subject.call
        end
        expect(result.success?).to eq true

        response = result.value

        expect(response.size).to eq 1
        expect(response.first['tags']).to eq ['baseline']
        expect(response.first['title']).to eq 'Test regarding baseline in sidebar'
      end
    end
  end
end
