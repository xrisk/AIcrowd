require 'rails_helper'

describe Api::V1::Organizers::OrganizersController, type: :request do
  describe '#show' do
    let(:request)     { get api_v1_organizer_path(organizer), headers: headers }
    let(:participant) { create(:participant, :admin) }
    let(:organizer)   { create(:organizer, organizer: 'Organizer Name') }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'renders organizer object' do
        request

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['organizer']).to eq 'Organizer Name'
      end
    end
  end

  describe '#create' do
    let(:request)     { post api_v1_organizers_path, headers: headers, params: params }
    let(:participant) { create(:participant, :admin) }
    let(:params) do
      {
        organizer: 'Organizer Name',
        tagline:   'Good Organizer'
      }
    end

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      context 'when params are valid' do
        it 'creates new organzer' do
          request

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['organizer']).to eq 'Organizer Name'
        end
      end

      context 'when params are invalid' do
        let(:params) do
          {
            organizer: 'Organizer Name'
          }
        end

        it 'returns error message' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq "Tagline can't be blank"
        end
      end
    end
  end

  describe '#update' do
    let!(:organizer)  { create(:organizer, organizer: 'Old Name') }
    let(:request)     { patch api_v1_organizer_path(organizer), headers: headers, params: params }
    let(:participant) { create(:participant, :admin) }

    let(:params) do
      {
        organizer: 'Organizer Name',
        tagline:   'Good Organizer'
      }
    end

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      context 'when params are valid' do
        it 'creates new organzer' do
          request

          expect(response).to have_http_status(:ok)
          expect(organizer.reload.organizer).to eq 'Organizer Name'
        end
      end

      context 'when params are invalid' do
        let(:params) do
          {
            organizer: 'Organizer Name',
            tagline:   nil
          }
        end

        it 'returns error message' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq "Tagline can't be blank"
        end
      end
    end
  end
end
