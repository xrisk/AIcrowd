require 'rails_helper'

RSpec.describe LandingPageController, type: :controller do
  render_views

  let!(:challenge_draft) do
    create :challenge,
           :draft,
           challenge: 'challenge_draft'
  end
  let!(:challenge_running) do
    create :challenge,
           :running,
           challenge: 'challenge_running'
  end
  let!(:challenge_completed) do
    create :challenge,
           :completed,
           challenge: 'challenge_completed'
  end
  let!(:challenge_starting_soon) do
    create :challenge,
           :starting_soon,
           challenge: 'challenge_starting_soon'
  end
  let!(:participant) { create :participant }
  let!(:admin) { create :participant, admin: true }

  context 'participant' do
    before do
      sign_in participant
    end

    describe 'GET #index challenge_running' do
      before { get :index }

      it { expect(assigns(:challenges).sort).to eq [challenge_running, challenge_completed, challenge_starting_soon].sort }
      it { expect(response).to render_template :index }
    end
  end

  context 'anonymous user' do
    describe 'GET #index challenge_running' do
      before { get :index }

      it { expect(assigns(:challenges).sort).to eq [challenge_running, challenge_completed, challenge_starting_soon].sort }
      it { expect(response).to render_template :index }
    end
  end

  context 'ordering of challenges' do
    describe 'GET #index challenge_running' do
      before { get :index }

      it { expect(assigns(:challenges)).to eq [challenge_running, challenge_completed, challenge_starting_soon] }
      it { expect(response).to render_template :index }
    end
  end
end
