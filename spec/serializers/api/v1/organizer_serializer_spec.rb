require 'rails_helper'

describe Api::V1::OrganizerSerializer do
  subject { described_class.new(organizer: organizer) }

  let(:organizer) { create(:organizer, organizer: 'Organizer Name') }

  describe '#serialize' do
    it 'serializes organizer object' do
      serialized_object = subject.serialize

      expect(serialized_object[:organizer]).to eq 'Organizer Name'
    end

    context 'when participants and participant_organizers associations are present' do
      let(:organizer)   { create(:organizer, participants: [participant], organizer: 'Organizer Name') }
      let(:participant) { create(:participant, name: 'test_username') }

      it 'serializes organizer object' do
        serialized_object = subject.serialize

        expect(serialized_object[:organizer]).to eq 'Organizer Name'
        expect(serialized_object[:participants].size).to eq 1
        expect(serialized_object[:participants].first[:name]).to eq 'test_username'
        expect(serialized_object[:participant_organizers].first[:participant_id]).to eq participant.id
      end
    end
  end
end
