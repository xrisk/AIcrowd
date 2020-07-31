require 'rails_helper'

describe Discourse::UpdateCategoryService do
  subject { described_class.new(challenge: challenge) }

  let(:challenge) { create(:challenge, challenge: 'Short Challenge Name', discourse_category_id: 30) }

  describe '#call' do
    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      context 'when challenge complies with discourse category validations' do
        it 'returns success and assigns discourse_category_id to challenge' do
          result = VCR.use_cassette('discourse_api/update/success') do
            subject.call
          end

          expect(result.success?).to eq true
        end
      end

      context 'when challenge name is to long' do
        let(:challenge) do
          create(
            :challenge,
            challenge:             'Way To Long Chalenge Name - aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            discourse_category_id: 30
          )
        end

        it 'truncates dicourse category name and returns success' do
          result = VCR.use_cassette('discourse_api/update/success_truncated_category_name') do
            subject.call
          end

          expect(result.success?).to eq true
        end
      end

      context 'when discourse category already exists' do
        let(:challenge) { create(:challenge, challenge: 'Discourse Category Name That Exists', discourse_category_id: 30) }

        it 'generates new category name and returns success' do
          result = VCR.use_cassette('discourse_api/update/success_generated_new_category_name') do
            subject.call
          end

          expect(result.success?).to eq true
        end
      end
    end
  end
end
