require 'rails_helper'

describe Discourse::UpsertUserService do
  subject { described_class.new(participant: participant) }

  describe '#call' do
    let(:participant) { create(:participant) }

    it_behaves_like 'Discourse ServiceObject class'

    context 'when discourse ENV variables are set' do
      context 'when participant exists in Discourse database' do
        let(:participant) { create(:participant, id: 7126, name: 'test', email: 'test@example.com') }

        it 'returns success' do
          result = VCR.use_cassette('discourse_api/update_user/partcipant_exists_success') do
            subject.call
          end

          expect(result.success?).to eq true
        end
      end

      context 'when participant exists in Discourse database' do
        let(:participant) { create(:participant, name: 'random123', email: 'random123@example.com') }

        it 'returns success' do
          result = VCR.use_cassette('discourse_api/update_user/partcipant_does_not_exist_success') do
            subject.call
          end

          expect(result.success?).to eq true
        end
      end
    end
  end
end
