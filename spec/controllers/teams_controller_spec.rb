require 'rails_helper'

# This is to make sure that the legacy `TeamsController` redirects as expected to
# the proper `Challenges::TeamsController` actions where possible
RSpec.describe TeamsController, type: :controller do
  render_views

  let!(:challenge) { create :challenge }

  context 'standard' do
    let!(:participant) { create :participant }
    let!(:team) { create :team, challenge: challenge, participants: [participant] }

    describe 'GET #show' do
      before { get :show, params: { name: team.name } }
      it { expect(response).to have_http_status(301) }
      it { expect(response).to redirect_to(challenge_team_url(team.challenge, team)) }
    end

    context 'with aliased team name' do
      let!(:challenge2) { create :challenge }
      let!(:participant2) { create :participant }
      let!(:team2) { create :team, name: team.name, challenge: challenge2, participants: [participant2] }

      describe 'GET #show' do
        before { get :show, params: { name: team2.name } }
        it { expect(response).to have_http_status(301) }
        it { expect(response).to redirect_to(challenge_team_url(team.challenge, team)) }
      end
    end
  end

  context 'with dotted names' do
    let!(:participant) { create :participant, name: 'participant.withdot' }
    let!(:team) { create :team, challenge: challenge, participants: [participant], name: 'team.withdot' }

    describe 'GET #show' do
      before do
        # we parse an actual path instead of using shortcuts to ensure routes are working properly
        path = team_path(team)
        params = Rails.application.routes.recognize_path(path)
        get(params[:action], params: params.except(:controller, :action))
      end
      it { expect(response).to have_http_status(301) }
      it { expect(response).to redirect_to(challenge_team_url(team.challenge, team)) }
    end
  end

  context 'with unknown name' do
    describe 'GET #show' do
      it { expect {
        get :show, params: { name: FFaker::Name.unique.first_name }
      }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
