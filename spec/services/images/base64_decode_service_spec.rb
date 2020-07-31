require 'rails_helper'

describe Images::Base64DecodeService do
  subject { described_class.new(base64_data: base64_data) }

  describe '#call' do
    context 'when valid base64 string provided' do
      let(:base64_data) do
        '/9j/4AAQSkZJRgABAQEASABIAAD/4gIcSUNDX1BST0ZJTEUAAQEAAAIMbGNtcwIQAABtbnRyUkdCIFhZWiAH3AABABkAAwApA'\
        'ADlhY3NwQVBQTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9tYAAQAAAADTLWxjbXMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'\
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApkZXNjAAAA/AAAAF5jcHJ0AAABXAAAAAt3dHB0AAABaAAAABRia3B0AAABfAAAAB'\
        'RyWFlaAAABkAAAABRnWFlaAAABpAAAABRiWFlaAAABuAAAABRyVFJDAAABzAAAAEBnVFJDAAABzAAAAEBiVFJDAAABzAAAAEB'\
        'kZXNjAAAAAAAAAANjMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'\
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB0ZXh0AAAAAElYAABYWVogAAAAAAAA9tYAAQAAAADTLVhZWiAAAAAAAAADFgAAAzMAA'\
        'AKkWFlaIAAAAAAAAG/Z'
      end

      it 'returns success and ActionDispatch::Http::UploadedFile object' do
        result = subject.call

        expect(result.success?).to eq true
        expect(result.value.class).to eq ActionDispatch::Http::UploadedFile
      end
    end

    context 'when invalid base64 string provided' do
      let(:base64_data) { 'INVALID_BASE_64_DATA' }

      it 'returns failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Not supported content type'
      end
    end
  end
end
