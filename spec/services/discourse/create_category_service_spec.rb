require 'rails_helper'

describe Discourse::CreateCategoryService do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge) }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      context 'when challenge complies with discourse category validations' do
        let(:challenge) { create(:challenge, challenge: 'Short Challenge Name', discourse_category_id: nil) }

        it 'returns success and assigns discourse_category_id to challenge' do
          result = VCR.use_cassette('discourse_api/create/success') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_category_id).to eq 30
        end
      end

      context 'when challenge organizer has participant that exists in Discourse' do
        let(:challenge)   { create(:challenge, organizers: [organizer]) }
        let(:organizer)   { create(:organizer, participants: [participant]) }
        let(:participant) { create(:participant, name: 'piotrekpasciakaaa') }

        it 'uses participant username as Discourse API username' do
          result = VCR.use_cassette('discourse_api/create/success_participant_username') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_category_id).to eq 290
        end
      end

      context 'when challenge organizer has participant but it does not exist in Discourse' do
        let(:challenge)   { create(:challenge, organizers: [organizer]) }
        let(:organizer)   { create(:organizer, participants: [participant]) }
        let(:participant) { create(:participant, name: 'not_existing_username') }

        it 'uses participant username as Discourse API username' do
          result = VCR.use_cassette('discourse_api/create/success_not_existing_username') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_category_id).to eq 292
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

        it 'truncates dicourse category name and returns success' do
          result = VCR.use_cassette('discourse_api/create/success_truncated_category_name') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_category_id).to eq 31
        end
      end

      context 'when discourse category already exists' do
        let(:challenge) { create(:challenge, challenge: 'Discourse Category Name That Exists', discourse_category_id: nil) }

        it 'generates new category name and returns success' do
          result = VCR.use_cassette('discourse_api/create/success_generated_new_category_name') do
            subject.call
          end

          expect(result.success?).to eq true
          expect(challenge.reload.discourse_category_id).to eq 33
        end
      end
    end
  end
end
