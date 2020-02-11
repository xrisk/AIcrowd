require 'rails_helper'

describe ChallengesController, type: :request do
  describe "#export" do
    let!(:challenge) { create(:challenge, challenge: 'Challenge Title') }

    context 'when user is logged in as participant' do
      let(:participant) { create(:participant) }

      before { login_as participant }

      it 'redirects to landing page and returns unauthorized flash' do
        get export_challenge_path(challenge)

        expect(response).to have_http_status :redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq 'You are not authorised to access this page.'
      end
    end

    context 'when user is logged in as admin' do
      let(:admin) { create(:participant, :admin) }

      before { login_as admin }

      it 'sends json file in response' do
        get export_challenge_path(challenge)

        expect(response).to have_http_status :ok
        expect(response.header['Content-Type']).to eq 'application/json'

        challenge_data = JSON.parse(response.body)

        expect(challenge_data['challenge']).to eq 'Challenge Title'
      end
    end
  end
end
