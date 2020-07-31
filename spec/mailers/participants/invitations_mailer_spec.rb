require 'rails_helper'

describe Participants::InvitationsMailer, type: :mailer do
  describe '#invitation_accepted_email' do
    subject { described_class.invitation_accepted_email(team_invitation) }

    let(:team_invitation) { create(:team_invitation, team: team, invitee: invitee, invitor: invitor) }
    let(:invitee)         { create(:participant, email: 'test@example.com') }
    let(:invitor)         { create(:participant) }
    let(:team)            { create(:team) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[AIcrowd] Welcome to Team #{team.name}"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'You’ve just joined'
    end
  end

  describe '#invitation_canceled_email' do
    subject { described_class.invitation_canceled_email(team_invitation) }

    let(:team_invitation) { create(:team_invitation, team: team, invitee: invitee, invitor: invitor) }
    let(:invitee)         { create(:participant, email: 'test@example.com') }
    let(:invitor)         { create(:participant) }
    let(:team)            { create(:team) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[AIcrowd] Your Invitation to Team #{team.name} Was Canceled"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'Unfortunately, your invitation has been canceled at this time.'
    end
  end

  describe '#invitation_pending_email' do
    subject { described_class.invitation_pending_email(team_invitation) }

    let(:team_invitation) { create(:team_invitation, team: team, invitee: invitee, invitor: invitor) }
    let(:invitee)         { create(:participant, email: 'test@example.com') }
    let(:invitor)         { create(:participant) }
    let(:team)            { create(:team) }

    it 'renders the headers' do
      expect(subject.subject).to eq "[AIcrowd] Invitation to Team #{team.name}"
      expect(subject.to).to eq ['test@example.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'You’ve been invited to join Team'
    end
  end
end
