require 'rails_helper'

describe Aws::FetchDatasetFolderService do
  subject { described_class.new(dataset_folder: dataset_folder) }

  describe '#call' do
    around do |spec|
      Aws.config.delete(:endpoint)
      Aws.config.delete(:force_path_style)
      spec.call
      Aws.config.update(endpoint: ENV['AWS_ENDPOINT'], force_path_style: true)
    end

    context 'when valid dataset_folder provided' do
      let(:dataset_folder) do
        create(:dataset_folder,
               directory_path: 'test_things',
               aws_access_key: 'REDACTED',
               aws_secret_key: 'REDACTED',
               bucket_name:    'test-s3-integratioon',
               region:         'eu-north-1',
               aws_endpoint:   '')
      end

      it 'returns success with list of dataset_files' do
        result = VCR.use_cassette('aws_api/fetch_dataset_folder/success') do
          subject.call
        end

        expect(result).to be_success
        expect(result.value.first.external_url[0..78]).to eq 'https://test-s3-integratioon.s3.eu-north-1.amazonaws.com/test_things/Screenshot'
      end
    end

    context 'when invalid dataset_folder provided' do
      let(:dataset_folder) do
        create(:dataset_folder,
               directory_path: 'test_things',
               aws_access_key: 'REDACTED',
               aws_secret_key: 'REDACTED',
               bucket_name:    'test-s3-integratioon',
               region:         'eu-north-1',
               aws_endpoint:   '')
      end

      it 'returns failure with error message' do
        result = VCR.use_cassette('aws_api/fetch_dataset_folder/failure') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq 'The AWS Access Key Id you provided does not exist in our records.'
      end
    end
  end
end
