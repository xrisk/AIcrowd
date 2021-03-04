require 'rails_helper'

describe DeviseAicrowdMailer, type: :mailer do
  let(:participant) { create(:participant, email: 'test@example.com') }
  let(:token)       { SecureRandom.hex(3) }

  describe '#reset_password_instructions' do
    subject { described_class.reset_password_instructions(participant, token) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Password Reset'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'You have been sent this email because a request was made to reset your password.'
    end
  end

  describe '#confirmation_instructions' do
    subject { described_class.confirmation_instructions(participant, token) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Confirmation Instructions'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'Click the button below to confirm your account on AIcrowd. This link can only be used once.'
    end
  end

  describe '#unlock_instructions' do
    subject { described_class.unlock_instructions(participant, token) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Unlock Instructions'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'Your account at AIcrowd has been locked due to an excessive number of unsuccessful sign in attempts.'
    end
  end
end
