require 'rails_helper'

describe Discourse::RemoveUsersFromGroupService do
  subject { described_class.new(challenge: challenge, usernames: usernames) }

  let(:challenge)          { create(:challenge, discourse_group_id: 71) }
  let(:first_participant)  { create(:participant, name: 'piotrekpasciakaaa') }
  let(:second_participant) { create(:participant, name: 'aicrowd-bot') }
  let(:usernames)          { 'piotrekpasciakaaa, aicrowd-bot' }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      context 'when challenge does not have discourse_group_id' do
        let(:challenge) { create(:challenge, discourse_group_id: nil) }

        it 'returns failure' do
          result = subject.call

          expect(result).to be_failure
          expect(result.value).to eq 'Discourse group doesn\'t exist in our database'
        end
      end

      context 'when usernames exist in Discourse database' do
        it 'returns success and removes users from group in discourse' do
          result = VCR.use_cassette('discourse_api/remove_users_from_group/success') do
            subject.call
          end

          expect(result).to be_success
        end
      end

      context 'when username is already out of the group' do
        it 'returns failure' do
          result = VCR.use_cassette('discourse_api/remove_users_from_group/failure_username_already_out_of_group') do
            subject.call
          end

          expect(result).to be_failure
          expect(result.value).to include('You supplied invalid parameters to the request: Discourse::InvalidParameters')
        end
      end

      context 'when usernames does not exist in Discourse database' do
        let(:usernames) { 'random_name, second_randomename' }

        it 'returns failure' do
          result = VCR.use_cassette('discourse_api/remove_users_from_group/failure_username_does_not_exist_in_discourse') do
            subject.call
          end

          expect(result).to be_failure
          expect(result.value).to include('You supplied invalid parameters to the request: usernames')
        end
      end
    end
  end
end
