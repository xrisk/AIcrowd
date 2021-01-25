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

    context 'when logged in as admin' do
      let(:admin) { create(:participant, :admin) }

      before { login_as admin }

      it 'sends csv file in response' do
        get export_challenge_submissions_path(challenge, submissions_export_challenge_round_id: challenge_round.id)

        expect(response).to have_http_status :ok
        # expect(response.header['Content-Type']).to eq 'text/csv'

        # csv_data = CSV.parse(response.body)

        # expect(csv_data.size).to eq 4
        # expect(csv_data[0][1]).to eq 'Type'
        # expect(csv_data[1][1]).to eq 'Participant'
      end
    end
  end
end
