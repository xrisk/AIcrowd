require 'rails_helper'

RSpec.describe Challenges::TeamsController, type: :controller do
  render_views

  let!(:challenge) { create :challenge }

  context 'standard' do
    let!(:participant) { create :participant }
    let!(:team) { create :team, challenge: challenge, participants: [participant] }

    describe 'GET #show' do
      before { get :show, params: { challenge_id: team.challenge.slug, name: team.name } }

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  context 'with dotted names' do
    let!(:participant) { create :participant, name: 'participant.withdot' }
    let!(:team) { create :team, challenge: challenge, participants: [participant], name: 'team.withdot' }

    describe 'GET #show' do
      before do
        # we parse an actual path instead of using shortcuts to ensure routes are working properly
        path   = challenge_team_path(team.challenge, team)
        params = Rails.application.routes.recognize_path(path)
        get(params[:action], params: params.except(:controller, :action))
      end

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
