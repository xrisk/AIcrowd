require 'rails_helper'

describe GdprMailer, type: :mailer do
  describe '#export_email' do
    subject { described_class.export_email(participant) }

    let(:participant) { create(:participant, email: 'test@example.com') }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Personal Data download'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'A request was made to download your personal data stored on AIcrowd. This data is attached to this email.'
    end
  end
end
