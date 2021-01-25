require 'rails_helper'

describe SubmissionsController, type: :request do
  describe '#export' do
    let!(:challenge)       { create(:challenge, challenge: 'Challenge Title') }
    let!(:challenge_round) { create(:challenge_round, challenge: challenge) }
    let!(:submissions)     { create_list(:submission, 3, challenge: challenge, challenge_round: challenge_round) }

    context 'when user is logged in as participant' do
      let(:participant) { create(:participant) }

      before { login_as participant }

      it 'redirects to landing page and returns unauthorized flash' do
        get export_challenge_submissions_path(challenge, submissions_export_challenge_round_id: challenge_round.id)

        expect(response).to have_http_status :redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq 'You are not authorised to access this page.'
      end
    end
  end
end
