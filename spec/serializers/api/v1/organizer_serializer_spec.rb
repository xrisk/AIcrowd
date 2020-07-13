require 'rails_helper'

describe Api::V1::OrganizerSerializer do
  subject { described_class.new(organizer: organizer) }

  let(:organizer) { create(:organizer, organizer: 'Organizer Name') }

  describe '#serialize' do
    it 'serializes organizer object' do
      serialized_object = subject.serialize

      expect(serialized_object[:organizer]).to eq 'Organizer Name'
    end
  end
end
