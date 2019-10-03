require 'rails_helper'

RSpec.describe Teams::Invitations::Controller, type: :controller do
  render_views

  let!(:challenge) { create :challenge }
  let!(:participant) { create :participant }

  before { sign_in participant }

  context 'POST #create' do
    def perform_request(team_name, invitee_name_or_email)
      # we parse an actual path instead of using shortcuts to ensure routes are working properly
      path = team_invitations_path(team_name: team_name)
      params = Rails.application.routes.recognize_path(path, method: :post)
      post(params[:action], params: params.except(:controller, :action).merge(invitee_name_or_email: invitee_name_or_email))
    end

    context 'with normal names' do
      let!(:invitee) { create :participant }
      let!(:team) { create :team, challenge: challenge, participants: [participant] }

      context 'passing names as-is' do
        before { perform_request(team.name, invitee.name) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(invitee) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end

      context 'passing names of incorrect case' do
        before { perform_request(team.name.swapcase, invitee.name.swapcase) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(invitee) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end

      context 'passing participant name that does not exist' do
        before { perform_request(team.name, FFaker::Name.unique.first_name) }
        it { expect(team.team_invitations.invitees_a).to eq([]) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:error]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end
    end

    context 'with dotted names' do
      let!(:invitee) { create :participant, :dotted_name }
      let!(:team) { create :team, :dotted_name, challenge: challenge, participants: [participant] }

      context 'passing names as-is' do
        before { perform_request(team.name, invitee.name) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(invitee) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end

      context 'passing names of incorrect case' do
        before { perform_request(team.name.swapcase, invitee.name.swapcase) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(invitee) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end

      context 'passing participant name that does not exist' do
        before { perform_request(team.name, FFaker::Name.unique.first_name) }
        it { expect(team.team_invitations.invitees_a).to eq([]) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:error]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end
    end

    context 'with emails' do
      let!(:p2) { create :participant }
      let!(:team) { create :team, challenge: challenge, participants: [participant] }

      context 'passing email of existing participant as-is' do
        before { perform_request(team.name, p2.email) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(p2) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end

      context 'passing email of incorrect case' do
        before { perform_request(team.name, p2.email.swapcase) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(p2) }
        it { expect(EmailInvitation.count).to eq(0) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end

      context 'passing email that does not exist' do
        before { perform_request(team.name, FFaker::Internet.unique.email) }
        it { expect(team.team_invitations.invitees_a).to contain_exactly(EmailInvitation.last) }
        it { expect(EmailInvitation.count).to eq(1) }
        it { expect(flash[:success]).to be }
        it { expect(response).to redirect_to(team_url(name: team.name)) }
      end
    end
  end
end
