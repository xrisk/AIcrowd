require 'rails_helper'

describe Organizers::InvitationsMailer, type: :mailer do
  let(:participant)     { create(:participant, email: 'test@example.com') }
  let(:team_invitation) { create(:team_invitation, team: team, invitee: invitee) }
  let(:invitee)         { create(:participant) }
  let(:team)            { create(:team) }

  describe '#accepted_notification_email' do
    subject { described_class.accepted_notification_email(participant, team_invitation) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Team Invitation Accepted'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'just accepted the invitation and is the newest member of the team.'
    end
  end

  describe '#declined_notification_email' do
    subject { described_class.declined_notification_email(participant, team_invitation) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[AIcrowd] Team Invitation Declined'
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'just declined an invitation to join Team'
    end
  end
end
