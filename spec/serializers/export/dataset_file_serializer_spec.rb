require 'rails_helper'

describe Export::DatasetFileSerializer, serializer: true do
  subject { described_class.new(dataset_file) }

  let(:dataset_file) { create(:dataset_file, description: 'Description') }

  describe '#as_json' do
    it 'returns serialized dataset_file' do
      serialized_dataset_file = subject.as_json

      expect(serialized_dataset_file[:description]).to eq 'Description'
    end
  end
end
