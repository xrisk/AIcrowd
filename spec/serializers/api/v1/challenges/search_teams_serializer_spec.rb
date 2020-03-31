require 'rails_helper'

describe Api::V1::Challenges::SearchTeamsSerializer, serializer: true do
  subject { described_class.new(teams: [first_team, second_team]).serialize }

  let(:first_team)  { create(:team, name: 'first_team', participants: [create(:participant, email: 'test@example.com')]) }
  let(:second_team) { create(:team, name: 'second_team') }

  describe '#serialize' do
    let(:expected_result) do
      {
        results: [
          { id: 'test@example.com', text: 'first_team'},
          { id: '', text: 'second_team'}
        ],
        processing: { more: false }
      }
    end

    it 'returns serialized participants' do
      expect(subject).to eq expected_result
    end
  end
end
