require 'rails_helper'

RSpec.describe Teams::Invitations::Controller, type: :controller do
  render_views

  let!(:challenge) { create :challenge }

  context 'standard' do
    let!(:participant) { create :participant }
    let!(:invitee) { create :participant }
    let!(:team) { create :team, challenge: challenge, participants: [participant] }

    before do
      sign_in participant
    end

    describe 'POST #create' do
      before { post(:create, params: { team_name: team.name, name: invitee.name }) }
      it { expect(team.team_invitations.pluck(:invitee_id)).to eq([invitee.id]) }
      it { expect(response).to redirect_to(team_url(name: team.name)) }
    end
  end

  context 'with dotted names' do
    let!(:participant) { create :participant, name: 'participant.withdot' }
    let!(:invitee) { create :participant, name: 'invitee.withdot' }
    let!(:team) { create :team, challenge: challenge, participants: [participant], name: 'team.withdot' }

    before do
      sign_in participant
    end

    describe 'POST #create' do
      def perform_request(name_or_email)
        # we parse an actual path instead of using shortcuts to ensure routes are working properly
        path = team_invitations_path(team_name: team.name)
        params = Rails.application.routes.recognize_path(path, method: :post)
        post(params[:action], params: params.except(:controller, :action).merge(name_or_email: name_or_email))
      end
      context 'with username'
        context 'of existing participant' do
          before { perform_request(invitee.name) }
          it { expect(team.team_invitations.invitees.to_a).to contain_exactly(invitee) }
          it { expect(EmailInvitation.count).to eq(0) }
          it { expect(response).to redirect_to(team_url(name: team.name)) }
        end
        context 'of nonexistant participant' do
          before { perform_request(FFaker::Name.unique.first_name) }
          it { expect(team.team_invitations.invitees.to_a).to eq([]) }
          it { expect(EmailInvitation.count).to eq(0) }
          it { expect(flash[:error]).to be }
          it { expect(response).to redirect_to(team_url(name: team.name)) }
        end
      end
      context 'with email' do
        context 'of existing participant' do
          before { perform_request(invitee.email) }
          it { expect(team.team_invitations.invitees.to_a).to contain_exactly(invitee) }
          it { expect(EmailInvitation.count).to eq(0) }
          it { expect(response).to redirect_to(team_url(name: team.name)) }
        end
        context 'of nonexistant participant' do
          before { perform_request(FFaker::Internet.unique.email) }
          it { expect(team.team_invitations.invitees.to_a).to contain_exactly(TeamEmailInvitation.first) }
          it { expect(EmailInvitation.count).to eq(1) }
          it { expect(response).to redirect_to(team_url(name: team.name)) }
        end
      end
    end
  end
end
