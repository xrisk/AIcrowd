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

  describe '#newsletter_email_notification_email' do
    subject { described_class.newsletter_email_notification_email(newsletter_email) }

    let!(:admin)           { create(:participant, :admin, email: 'test@example.com') }
    let(:challenge)        { create(:challenge, challenge: 'Example Title') }
    let(:newsletter_email) { create(:newsletter_email, challenge: challenge) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[#{challenge.challenge}] New newsletter email is waiting for verification"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'New newsletter e-mail was submitted'
    end
  end

  describe '#organizer_application_notification_email' do
    subject { described_class.organizer_application_notification_email(participant, organizer_application) }

    let(:participant)           { create(:participant, :admin, email: 'test@example.com') }
    let(:organizer_application) { create(:organizer_application) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[ADMIN:AIcrowd] Organizer Application Requested'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'A new Organizer Application has been made.'
    end
  end

  describe '#submission_notification_email' do
    subject { described_class.submission_notification_email(participant, submission) }

    let(:participant) { create(:participant, :admin, email: 'test@example.com') }
    let(:challenge)   { create(:challenge, :running) }
    let(:submission)  { create(:submission, challenge: challenge) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[ADMIN:AIcrowd/#{challenge.challenge}] Submission made"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'A new submission has been made'
    end
  end
end
