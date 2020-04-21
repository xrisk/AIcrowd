require 'rails_helper'

describe Discourse::FetchTopContributorsService, :requests_allowed do
  subject { described_class.new }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

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
  end
end
