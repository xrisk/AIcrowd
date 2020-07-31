require 'rails_helper'

describe Aws::FetchDatasetFileService do
  subject { described_class.new(dataset_file: dataset_file) }

  describe '#call' do
    around do |spec|
      Aws.config.delete(:endpoint)
      Aws.config.delete(:force_path_style)
      spec.call
      Aws.config.update(endpoint: ENV['AWS_ENDPOINT'], force_path_style: true)
    end

    context 'when valid dataset_file provided' do
      let(:dataset_file) do
        create(:dataset_file,
               file_path:      'other_dataset/8d8183c9-4705-48d7-add1-22653634477f_archived-datasets.txt',
               aws_access_key: 'REDACTED',
               aws_secret_key: 'REDACTED',
               bucket_name:    'test-s3-integratioon',
               region:         'eu-north-1')
      end

      it 'returns success with dataset_file url' do
        result = VCR.use_cassette('aws_api/fetch_dataset_file/success') do
          subject.call
        end

        expect(result).to be_success
        expect(result.value[:url][0..128]).to eq 'https://test-s3-integratioon.s3.eu-north-1.amazonaws.com/other_dataset/8d8183c9-4705-48d7-add1-22653634477f_archived-datasets.txt'
      end
    end

    context 'when invalid api keys provided' do
      let(:dataset_file) do
        create(:dataset_file,
               file_path:      'other_dataset/8d8183c9-4705-48d7-add1-22653634477f_archived-datasets.txt',
               aws_access_key: 'INVALID_KEY',
               aws_secret_key: 'INVALID_KEY',
               bucket_name:    'test-s3-integratioon',
               region:         'eu-north-1')
      end

      it 'returns failure with error message' do
        result = VCR.use_cassette('aws_api/fetch_dataset_file/invalid_api_keys') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq 'AWS credentials, bucket name or region are incorrect.'
      end
    end

    context 'when invalid parameters provided' do
      let(:dataset_file) do
        create(:dataset_file,
               file_path:      'INVALID',
               aws_access_key: 'INVALID_KEY',
               aws_secret_key: 'INVALID_KEY',
               bucket_name:    'INVALID',
               region:         'eu-north-1')
      end

      it 'returns failure with error message' do
        result = VCR.use_cassette('aws_api/fetch_dataset_file/invalid_parameters') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq 'AWS credentials, bucket name or region are incorrect.'
      end
    end
  end
end
