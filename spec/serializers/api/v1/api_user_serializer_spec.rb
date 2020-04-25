require 'rails_helper'

describe Api::V1::ApiUserSerializer, serializer: true do
  subject { described_class.new(participant: participant) }

  let(:participant) { create(:participant, first_name: 'Jhon') }

  describe '#serialize' do
    it 'serializes participant object' do
      serialized_object = subject.serialize

      expect(serialized_object[:first_name]).to eq 'Jhon'
    end
  end
end
