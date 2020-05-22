require 'rails_helper'

describe Organizers::NotificationsMailer, type: :mailer do
  describe '#eua_notification_email' do
    subject { described_class.eua_notification_email(organizer_participant, clef_task, participant) }

    let(:organizer_participant) { create(:participant, email: 'test@example.com') }
    let(:participant)           { create(:participant) }
    let(:clef_task)             { create(:clef_task, challenges: [create(:challenge, :running)]) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[ImageCLEF AICrowd] - New EUA uploaded for #{clef_task.task}"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'has uploaded an End User Agreement'
    end
  end
end
