require 'rails_helper'

RSpec.describe Challenges::TeamInvitationsController, type: :controller do
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
      before { post(:create, params: { challenge_id: team.challenge.slug, team_name: team.name, name: invitee.name }) }
      it { expect(team.team_invitations.pluck(:invitee_id)).to eq([invitee.id]) }
      it { expect(response).to redirect_to(challenge_team_url(team.challenge, team)) }
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
      before do
        # we parse an actual path instead of using shortcuts to ensure routes are working properly
        path = challenge_team_invitations_path(team.challenge, team)
        params = Rails.application.routes.recognize_path(path, method: :post)
        post(params[:action], params: params.except(:controller, :action).merge(name: invitee.name))
      end
      it { expect(team.team_invitations.pluck(:invitee_id)).to eq([invitee.id]) }
      it { expect(response).to redirect_to(challenge_team_url(team.challenge, team)) }
    end
  end
end
