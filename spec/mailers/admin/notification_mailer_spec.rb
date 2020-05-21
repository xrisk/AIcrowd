require 'rails_helper'

describe Admin::NotificationsMailer, type: :mailer do
  describe '#challenge_call_response_email' do
    subject { described_class.challenge_call_response_email(participant, challenge_call_response) }

    let(:participant)             { create(:participant, email: 'test@example.com') }
    let(:challenge_call_response) { create(:challenge_call_response) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[ADMIN:AIcrowd] Challenge Call response'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'A new Challenge Call Response has been received.'
    end
  end
end
