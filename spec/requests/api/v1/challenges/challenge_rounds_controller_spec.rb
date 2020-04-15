require 'rails_helper'

describe Api::V1::Challenges::ChallengeRoundsController, type: :request do
  describe '#destroy' do
    let(:challenge)       { create(:challenge, :running) }
    let(:challenge_round) { create(:challenge_round, challenge: challenge) }

    context 'when participant is not logged in' do
      it 'returns unauthorized response' do
        delete api_v1_challenge_challenge_round_path(challenge, challenge_round)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq 'You are not authorized to perform this action'
      end
    end

    context 'when participant is lgoged in as admin' do
      let(:admin) { create(:participant, :admin) }

      before { login_as admin }

      context 'when challenge_round is generic' do
        it 'returns success response' do
          delete api_v1_challenge_challenge_round_path(challenge, challenge_round)

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when challenge_round has submissions' do
        let!(:submission) { create(:submission, challenge_round: challenge_round) }

        it 'returns unprocessable_entity response' do
          delete api_v1_challenge_challenge_round_path(challenge, challenge_round)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
