require 'rails_helper'

describe Api::V1::ApiUsersController, type: :request do
  describe '#show' do
    let(:request) { get api_v1_api_user_path, headers: headers }

    let(:participant) { create(:participant, first_name: 'Jhon') }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'CONTENT_TYPE':  'application/json',
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'creates new challenge' do
        request

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['first_name']).to eq 'Jhon'
      end
    end
  end
end
