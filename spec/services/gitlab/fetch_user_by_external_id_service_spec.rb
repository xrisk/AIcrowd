require 'rails_helper'

describe Gitlab::FetchUserByExternalIdService do
  subject { described_class.new(participant: participant) }

  describe '#call' do
    let(:participant) { create(:participant) }

    it_behaves_like 'Gitlab ServiceObject class'

    context 'when participant exists in Gitlab' do
      let(:participant) { create(:participant, id: 7126) }

      it 'returns success with user data and assigns gitlab_id' do
        result = VCR.use_cassette('gitlab_api/fetch_user_by_external_id/success') do
          subject.call
        end

        expect(result).to be_success

        user_data = result.value

        expect(user_data['id']).to eq 2679
        expect(user_data['username']).to eq 'piotrekpasciakaaa'
        expect(participant.reload.gitlab_id).to eq 2679
      end
    end

    context 'when participant does not exist in Gitlab' do
      let(:participant) { create(:participant, id: 123_456) }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/fetch_user_by_external_id/user_not_found') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq 'User not found in Gitlab API'
      end
    end
  end
end
