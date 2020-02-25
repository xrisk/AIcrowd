require 'rails_helper'

describe Export::SubmissionFileDefinitionSerializer, serializer: true do
  subject { described_class.new(submission_file_definition) }

  let(:submission_file_definition) { create(:submission_file_definition, submission_file_description: 'Submission File Description') }

  describe '#as_json' do
    it 'returns serialized submission_file_definition' do
      serialized_submission_file_definition = subject.as_json

      expect(serialized_submission_file_definition[:submission_file_description]).to eq 'Submission File Description'
    end
  end
end
