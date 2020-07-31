require 'rails_helper'

describe Images::Base64EncodeService do
  subject { described_class.new(image_url: image_url) }

  around do |example|
    VCR.configure do |config|
      config.ignore_localhost = false
    end
    example.run
    VCR.configure do |config|
      config.ignore_localhost = true
    end
  end

  describe '#call' do
    context 'when valid image_url is provided and image exists' do
      let(:image_url) { 'http://localhost:3000/assets/images/challenges/image_file/373/cat.jpeg' }

      it 'returns success and encoded image string' do
        result = VCR.use_cassette('images/base64_encode_service/success') do
          subject.call
        end

        expect(result.success?).to eq true
        expect(result.value[0..3]).to eq '/9j/'
      end
    end

    context 'when valid image_url is provided and image does not exist' do
      let(:image_url) { 'http://localhost:3000/assets/images/not_existing_image_url.jpeg' }

      it 'returns failure and error message' do
        result = VCR.use_cassette('images/base64_encode_service/failure_missing_image') do
          result = subject.call
        end

        expect(result.success?).to eq false
        expect(result.value).to eq 'There is no image under provided URL'
      end
    end

    context 'when invalid image_url is provided' do
      let(:image_url) { 'INVALID_URL' }

      it 'returns failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'URL is invalid'
      end
    end
  end
end
