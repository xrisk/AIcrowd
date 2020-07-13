require 'rails_helper'

describe Api::V1::ParticipantOrganizerSerializer do
  subject { described_class.new(participant_organizer: participant_organizer) }

  let(:participant_organizer) { create(:participant_organizer, organizer: create(:organizer, id: 10)) }

  describe '#serialize' do
    it 'serializes participant_organizer object' do
      serialized_object = subject.serialize

      expect(serialized_object[:organizer_id]).to eq 10
    end
  end
end
