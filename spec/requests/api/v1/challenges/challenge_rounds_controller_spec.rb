require 'rails_helper'

describe Api::V1::Challenges::ChallengeRoundsController, type: :request do
  let!(:challenge) { create(:challenge, :running) }

  describe '#create' do
    let(:request) { post api_v1_challenge_challenge_rounds_path(challenge), headers: headers, params: params }
    let(:params) do
      {
        challenge_round: {
          challenge_round:  'ChallengeRound Title',
          active:           false,
          submission_limit: 5
        }
      }
    end

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when participant is logged in as admin' do
      let(:participant) { create(:participant, :admin) }
      let(:headers)     { { 'Authorization': auth_header(participant.api_key) } }

      it 'creates new ChallengeRound' do
        expect { request }.to change { ChallengeRound.count }.by(1)

        expect(response).to have_http_status(:created)
      end
    end
  end

  describe '#update' do
    let(:request) { patch api_v1_challenge_challenge_round_path(challenge, challenge_round), headers: headers, params: params }
    let(:challenge_round) { create(:challenge_round, challenge: challenge, challenge_round: 'Old Title') }
    let(:params) do
      {
        challenge_round: {
          challenge_round:  'Updated ChallengeRound Title',
          active:           false,
          submission_limit: 5
        }
      }
    end

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when participant is logged in as admin' do
      let(:participant)     { create(:participant, :admin) }
      let(:headers)         { { 'Authorization': auth_header(participant.api_key) } }

      it 'updates ChallengeRound' do
        request

        expect(response).to have_http_status(:ok)
        expect(challenge_round.reload.challenge_round).to eq 'Updated ChallengeRound Title'
      end
    end
  end

  describe '#destroy' do
    let(:request)         { delete api_v1_challenge_challenge_round_path(challenge, challenge_round) }
    let(:challenge_round) { create(:challenge_round, challenge: challenge) }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when participant is lgoged in as admin' do
      let(:admin) { create(:participant, :admin) }

      before { login_as admin }

      context 'when challenge_round is generic' do
        it 'returns success response' do
          request

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when challenge_round has submissions' do
        let!(:submission) { create(:submission, challenge_round: challenge_round) }

        it 'returns unprocessable_entity response' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
