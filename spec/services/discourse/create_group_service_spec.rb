require 'rails_helper'

describe Discourse::CreateGroupService do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge) }

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
      context 'when challenge complies with discourse group validations' do
        let(:challenge) { create(:challenge, challenge: 'Short Challenge Name', discourse_group_id: nil) }

        it 'returns success and assigns discourse_group_id to challenge' do
          result = VCR.use_cassette('discourse_api/groups/create/success') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_group_id).to eq 49
        end
      end

      context 'when challenge name is to long' do
        let(:challenge) do
          create(
            :challenge,
            challenge: 'Way To Long Chalenge Name - aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            discourse_category_id: nil
          )
        end

        it 'truncates dicourse group name and returns success' do
          result = VCR.use_cassette('discourse_api/groups/create/success_truncated_group_name') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_group_id).to eq 50
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
        end
      end

      context 'when discourse API is unavailable' do
        let(:challenge) { create(:challenge, challenge: 'Short Challenge Name', discourse_group_id: nil) }

        before do
          allow_any_instance_of(Faraday::Connection).to receive(:post).and_raise(Discourse::Error)
        end

        it 'returns failure' do
          result = subject.call

          expect(result.success?).to eq false
          expect(result.value).to eq 'Discourse::Error'
        end
      end
    end
  end
end
