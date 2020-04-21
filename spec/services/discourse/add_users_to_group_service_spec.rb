require 'rails_helper'

describe Discourse::AddUsersToGroupService do
  subject { described_class.new(challenge: challenge, participants: participants) }

  let(:challenge)          { create(:challenge, discourse_group_id: 50) }
  let(:first_participant)  { create(:participant, name: 'piotrekpasciakaaa') }
  let(:second_participant) { create(:participant, name: 'aicrowd-bot') }
  let(:participants)       { [first_participant, second_participant] }

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
        it 'returns success and assigns users to group in discourse' do
          result = VCR.use_cassette('discourse_api/add_users_to_group/success') do
            subject.call
          end

          expect(result).to be_success
        end
      end

      context 'when username is already part of the group' do
        it 'returns failure' do
          result = VCR.use_cassette('discourse_api/add_users_to_group/failure_username_already_part_of_the_group') do
            subject.call
          end

          expect(result).to be_failure
          expect(result.value).to include('is already a member of this group')
        end
      end

      context 'when usernames does not exist in Discourse database' do
        let(:first_participant)  { create(:participant, name: 'random_name') }
        let(:second_participant) { create(:participant, name: 'second_randomename') }

        it 'raises Discourse::BadRequest error' do
          VCR.use_cassette('discourse_api/add_users_to_group/failure_username_does_not_exist_in_discourse') do
            expect { subject.call }.to raise_error(Discourse::BadRequest)
          end
        end
      end
    end
  end
end
