require 'rails_helper'

describe Api::V1::FeedbackSerializer do
  subject { described_class.new(feedback: feedback) }

  let(:feedback) { create(:feedback, message: '<p>Feedback message</p>') }

  describe '#serialize' do
    it 'serializes feedback object' do
      serialized_object = subject.serialize

      expect(serialized_object[:message]).to eq '<p>Feedback message</p>'
    end
  end
end
