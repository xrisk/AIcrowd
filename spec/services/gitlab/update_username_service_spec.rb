require 'rails_helper'

describe Gitlab::UpdateUsernameService do
  subject { described_class.new(participant: participant) }

  describe '#call' do
    let(:participant) { create(:participant, gitlab_id: 2679) }

    it_behaves_like 'Gitlab ServiceObject class'

    context 'when participant exists in Gitlab' do
      let(:participant) { create(:participant, name: 'test', email: 'test@gmail.com', gitlab_id: 2679) }

      it 'return success' do
        result = VCR.use_cassette('gitlab_api/update_username/success') do
          subject.call
        end

        expect(result).to be_success

        response = result.value

        expect(response['id']).to eq 2679
        expect(response['name']).to eq 'test'
        expect(response['username']).to eq 'test'
      end
    end

    context 'when participant does not exist in Gitlab' do
      let(:participant) { create(:participant, name: 'test', email: 'test@example.com', gitlab_id: 123_456) }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/update_username/user_not_found') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq '{"message"=>"404 User Not Found"}'
      end
    end
  end
end
