require 'rails_helper'

describe Organizers::NotificationsMailer, type: :mailer do
  describe '#eua_notification_email' do
    subject { described_class.eua_notification_email(organizer_participant, clef_task, participant) }

    let(:organizer_participant) { create(:participant, email: 'test@example.com') }
    let(:participant)           { create(:participant) }
    let(:challenge)             { create(:challenge, :running) }
    let(:clef_task)             { create(:clef_task, challenges: [challenge]) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[#{challenge&.challenge}] - New EUA uploaded for #{clef_task.task}"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'has uploaded an End User Agreement'
    end
  end

  describe '#received_application_email' do
    subject { described_class.received_application_email(organizer_application) }

    let(:organizer_application) { create(:organizer_application, email: 'test@example.com') }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Organizer Application Received'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'We have received your application to become a AIcrowd organizer. You will be contacted by a member of our team.'
    end
  end
end
