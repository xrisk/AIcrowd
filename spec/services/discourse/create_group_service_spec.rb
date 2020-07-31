require 'rails_helper'

describe Discourse::CreateGroupService do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge) }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      context 'when challenge complies with discourse group validations' do
        let(:challenge) { create(:challenge, challenge: 'Short Challenge Name', discourse_group_id: nil) }

        it 'returns success and assigns discourse_group_id to challenge' do
          result = VCR.use_cassette('discourse_api/groups/create/success') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_group_id).to eq 49
          expect(challenge.discourse_group_name).to eq 'short-challenge-name'
        end
      end

      context 'when challenge name is to long' do
        let(:challenge) do
          create(
            :challenge,
            challenge:             'Way To Long Chalenge Name - aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            discourse_category_id: nil
          )
        end

        it 'truncates dicourse group name and returns success' do
          result = VCR.use_cassette('discourse_api/groups/create/success_truncated_group_name') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_group_id).to eq 50
          expect(challenge.discourse_group_name).to eq 'way-to-long-chalenge'
        end
      end

      context 'when discourse group already exists' do
        let(:challenge) { create(:challenge, challenge: 'Discourse Category Name That Exists', discourse_group_id: nil) }

        it 'generates new group name and returns success' do
          result = VCR.use_cassette('discourse_api/groups/create/success_generated_new_group_name') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_group_id).to eq 52
          expect(challenge.discourse_group_name).to eq 'discourse-cat-098b7a'
        end
      end
    end
  end
end
