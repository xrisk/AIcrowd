require 'rails_helper'

describe Api::V1::DatasetFolderSerializer, serializer: true do
  subject { described_class.new(dataset_folder: dataset_folder) }

  let(:dataset_folder) { create(:dataset_folder, title: 'Title') }

  describe '#serialize' do
    it 'serializes dataset_folder object' do
      serialized_object = subject.serialize

      expect(serialized_object[:title]).to eq 'Title'
    end
  end
end
