require 'rails_helper'

RSpec.describe Teams::Controller, type: :controller do
  render_views

  let!(:challenge) { create :challenge }

  context 'standard' do
    let!(:participant) { create :participant }
    let!(:team) { create :team, challenge: challenge, participants: [participant] }

    describe 'GET #show' do
      before { get :show, params: { name: team.name } }
      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(200) }
    end
  end

  context 'with dotted names' do
    let!(:participant) { create :participant, name: 'participant.withdot' }
    let!(:team) { create :team, challenge: challenge, participants: [participant], name: 'team.withdot' }

    describe 'GET #show' do
      before do
        # we parse an actual path instead of using shortcuts to ensure routes are working properly
        path = team_path(name: team.name)
        params = Rails.application.routes.recognize_path(path)
        get(params[:action], params: params.except(:controller, :action))
      end
      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(200) }
    end
  end
end
