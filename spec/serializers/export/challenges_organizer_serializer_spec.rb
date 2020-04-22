require 'rails_helper'

describe Export::ChallengesOrganizerSerializer, serializer: true do
  subject { described_class.new(challenges_organizer) }

  let(:organizer)            { create(:organizer, id: 2) }
  let(:challenges_organizer) { create(:challenges_organizer, organizer: organizer) }

  describe '#as_json' do
    it 'returns serialized challenges_organizer' do
      serialized_challenges_organizer = subject.as_json

      expect(serialized_challenges_organizer[:organizer_id]).to eq 2
    end
  end
end
