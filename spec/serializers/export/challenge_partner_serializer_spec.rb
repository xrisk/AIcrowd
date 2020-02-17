require 'rails_helper'

describe Export::ChallengePartnerSerializer, serializer: true do
  subject { described_class.new(challenge_partner) }

  let(:challenge_partner) { create(:challenge_partner, partner_url: 'https://www.google.com') }

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
    it 'returns serialized challenge_partner' do
      serialized_challenge_partner = VCR.use_cassette('images/base64_encode_service/default_image_success') do
        subject.as_json
      end

      expect(serialized_challenge_partner[:partner_url]).to eq 'https://www.google.com'
    end
  end
end
