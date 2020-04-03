require 'rails_helper'

describe Api::V1::Challenges::ParticipantsController, type: :request do
  let(:challenge)          { create(:challenge, :running) }
  let(:first_participant)  { create(:participant, name: 'first') }
  let(:second_participant) { create(:participant, name: 'second') }

  let!(:first_challenge_participant)  { create(:challenge_participant, challenge: challenge, participant: first_participant) }
  let!(:second_challenge_participant) { create(:challenge_participant, challenge: challenge, participant: second_participant) }
  let!(:other_challenge_participant)  { create(:challenge_participant) }

  describe '#search' do
    let(:parsed_response) { JSON.parse(response.body) }

    context 'when q parameter not provided' do
      it 'returns success with all challenge participants' do
        get search_api_v1_challenge_participants_path(challenge)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['results'].size).to eq 2
      end
    end

    context 'when q parameter provided' do
      it 'returns success with participant that\'s matching the query' do
        get search_api_v1_challenge_participants_path(challenge), params: { q: 'second' }

        expect(response).to have_http_status(:ok)
        expect(parsed_response['results'].size).to eq 1
        expect(parsed_response['results'].first['text']).to eq 'second'
      end
    end
  end
end
