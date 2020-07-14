require 'rails_helper'

describe Api::V1::ParticipantSerializer do
  subject { described_class.new(participant: participant) }

  let(:participant) { create(:participant, name: 'test_username') }

  describe '#serialize' do
    it 'serializes participant object' do
      serialized_object = subject.serialize

      expect(serialized_object[:name]).to eq 'test_username'
    end
  end
end
