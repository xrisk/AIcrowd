require 'rails_helper'

describe Api::V1::Challenges::ChallengesController, type: :request do
  let!(:first_organizer)  { create(:organizer, id: 1) }
  let!(:second_organizer) { create(:organizer, id: 2) }

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
        let(:participant) { create(:participant, organizers: [first_organizer]) }
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

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']).to eq 'You are not authorized to perform this action'
        end
      end
    end
  end

  describe '#update' do
    let!(:challenge) { create(:challenge, :running, organizers: [first_organizer]) }

    let(:challenge_round) { challenge.challenge_rounds.first }

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
        let(:participant) { create(:participant, organizers: [first_organizer]) }
        let(:headers) do
          {
            'CONTENT_TYPE':  'application/json',
            'Authorization': auth_header(participant.api_key)
          }
        end

        context 'when challenge has challenge_rounds with submission' do
          let!(:submission) { create(:submission, challenge: challenge, challenge_round: challenge_round) }

          it 'updates existing challenge' do
            patch api_v1_challenge_path(challenge), params: file_fixture('json/challenge_import.json').read, headers: headers

            expect(response).to have_http_status(:ok)
          end
        end

        context 'when challenge has dataset_files' do
          let!(:dataset_files) { create_list(:dataset_file, 3, challenge: challenge) }

          it 'doesn\'t import new dataset files' do
            expect(challenge.dataset_files.count).to eq 4

            patch api_v1_challenge_path(challenge), params: file_fixture('json/challenge_import.json').read, headers: headers

            expect(response).to have_http_status(:ok)
            expect(challenge.reload.dataset_files.count).to eq 4
          end
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

        it 'returns unauthorized response' do
          patch api_v1_challenge_path(challenge), params: file_fixture('json/challenge_import.json').read, headers: headers

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']).to eq 'You are not authorized to perform this action'
        end
      end
    end
  end
end
