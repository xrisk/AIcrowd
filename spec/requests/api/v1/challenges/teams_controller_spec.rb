require 'rails_helper'

describe Api::V1::Challenges::TeamsController, type: :request do
  let(:first_team)  { create(:team, name: 'first') }
  let(:second_team) { create(:team, name: 'second') }
  let(:challenge)   { create(:challenge, :running) }

  let!(:first_challenge_team)  { create(:team, challenge: challenge, name: 'first') }
  let!(:second_challenge_team) { create(:team, challenge: challenge, name: 'second') }
  let!(:other_challenge_team)  { create(:team) }

  describe '#search' do
    let(:parsed_response) { JSON.parse(response.body) }

    context 'when q parameter not provided' do
      it 'returns success with all challenge teams' do
        get search_api_v1_challenge_teams_path(challenge)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['results'].size).to eq 2
      end
    end

    context 'when q parameter provided' do
      it 'returns success with team that\'s matching the query' do
        get search_api_v1_challenge_teams_path(challenge), params: { q: 'second' }

        expect(response).to have_http_status(:ok)
        expect(parsed_response['results'].size).to eq 1
        expect(parsed_response['results'].first['text']).to eq 'second'
      end
    end
  end
end
