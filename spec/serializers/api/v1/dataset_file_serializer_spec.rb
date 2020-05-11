require 'rails_helper'

describe Api::V1::DatasetFileSerializer, serializer: true do
  subject { described_class.new(dataset_file: dataset_file) }

  let(:dataset_file) { create(:dataset_file, title: 'Title') }

  describe '#serialize' do
    it 'serializes dataset_file object' do
      serialized_object = subject.serialize

      expect(serialized_object[:title]).to eq 'Title'
    end
  end
end
