require 'rails_helper'

describe Api::V1::Challenges::ChallengesController, type: :request do
  let(:organizer) { create(:organizer) }

  describe '#create' do
    context 'when authenticity token not provided' do
      let(:headers) { { 'CONTENT_TYPE':  'application/json' } }

      it 'returns unauthorized response' do
        post api_v1_challenges_path, params: file_fixture('json/challenge_import.json').read, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq "HTTP Token: Access denied.\n"
      end
    end

    context 'when authenticity token provided' do
      context 'when user is organizer' do
        let(:participant) { create(:participant, organizers: [organizer]) }
        let(:headers) do
          {
            'CONTENT_TYPE':  'application/json',
            'Authorization': auth_header(participant.api_key)
          }
        end

        it 'creates new challenge' do
          expect { post api_v1_challenges_path, params: file_fixture('json/challenge_import.json').read, headers: headers }.to change { Challenge.count }.by(1)

          expect(response).to have_http_status(:created)
        end
      end

      context 'when user is not organizer' do
        let(:participant) { create(:participant) }
        let(:headers) do
          {
            'CONTENT_TYPE':  'application/json',
            'Authorization': auth_header(participant.api_key)
          }
        end

        it 'creates new challenge' do
          post api_v1_challenges_path, params: file_fixture('json/challenge_import.json').read, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq 'Import failed: At least one organizer must be provided'
        end
      end
    end
  end

  describe '#update' do
    let!(:challenge) { create(:challenge, :running, organizers: [organizer]) }

    context 'when authenticity token not provided' do
      let(:headers) { { 'CONTENT_TYPE':  'application/json' } }

      it 'returns unauthorized response' do
        patch api_v1_challenge_path(challenge), params: file_fixture('json/challenge_import.json').read, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq "HTTP Token: Access denied.\n"
      end
    end

    context 'when authenticity token provided' do
      context 'when user is challenge organizer' do
        let(:participant) { create(:participant, organizers: [organizer]) }
        let(:headers) do
          {
            'CONTENT_TYPE':  'application/json',
            'Authorization': auth_header(participant.api_key)
          }
        end

        it 'updates existing challenge' do
          patch api_v1_challenge_path(challenge), params: file_fixture('json/challenge_import.json').read, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is not challenge organizer' do
        let(:participant) { create(:participant) }
        let(:headers) do
          {
            'CONTENT_TYPE':  'application/json',
            'Authorization': auth_header(participant.api_key)
          }
        end

        it 'updates existing challenge' do
          patch api_v1_challenge_path(challenge), params: file_fixture('json/challenge_import.json').read, headers: headers

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']).to eq 'You are not authorized to perform this action'
        end
      end
    end
  end
end
