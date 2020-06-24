require 'rails_helper'

describe Export::ChallengeSerializer, serializer: true do
  subject { described_class.new(challenge) }

  let(:challenge) { create(:challenge, :running, challenge: 'Challenge Title', id: 3) }

  around do |example|
    VCR.configure do |config|
      config.ignore_localhost = false
    end
    example.run
    VCR.configure do |config|
      config.ignore_localhost = true
    end
  end

  describe '#as_json' do
    it 'returns serialized challenge' do
      serialized_challenge = VCR.use_cassette('images/base64_encode_service/default_challenge_image_success') do
        subject.as_json
      end

      expect(serialized_challenge[:challenge]).to eq 'Challenge Title'
    end
  end
end
