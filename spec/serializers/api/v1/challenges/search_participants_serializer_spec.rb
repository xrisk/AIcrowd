require 'rails_helper'

describe Api::V1::Challenges::SearchParticipantsSerializer, serializer: true do
  subject { described_class.new(participants: [first_participant, second_participant]).serialize }

  let(:first_participant)  { create(:participant, name: 'joe', email: 'joe@example.com' ) }
  let(:second_participant) { create(:participant, name: 'test', email: 'test@example.com') }

  describe '#serialize' do
    let(:expected_result) do
      {
        results: [
          { id: 'joe@example.com', text:  'joe'},
          { id: 'test@example.com', text: 'test'}
        ],
        processing: { more: false }
      }
    end

    it 'returns serialized participants' do
      expect(subject).to eq expected_result
    end
  end
end
