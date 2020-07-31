require 'rails_helper'

describe Api::V1::Organizers::ParticipantOrganizersController, type: :request do
  describe '#create' do
    let(:request)         { post api_v1_organizer_participant_organizers_path(organizer), headers: headers, params: params }
    let(:admin)           { create(:participant, :admin) }
    let(:organizer)       { create(:organizer, participants: [old_participant]) }
    let(:old_participant) { create(:participant) }
    let(:new_participant) { create(:participant, id: 10, name: 'test_participant') }

    let(:params) do
      {
        participant_id: new_participant.id
      }
    end

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(admin.api_key)
        }
      end

      context 'when params are valid' do
        it 'creates new participant_organzer' do
          request

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['participant_id']).to eq 10
        end
      end

      context 'when participant name provided in params' do
        let(:params) do
          {
            name: new_participant.name
          }
        end

        it 'creates new participant based on name parameter' do
          request

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['participant_id']).to eq 10
        end
      end

      context 'when params are invalid' do
        let(:params) do
          {
            participant_id: old_participant.id
          }
        end

        it 'returns error message' do
          request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq 'Participant has already been taken'
        end
      end
    end
  end

  describe '#destroy' do
    let(:request)                { delete api_v1_organizer_participant_organizer_path(organizer, participant_organizer), headers: headers }
    let(:admin)                  { create(:participant, :admin) }
    let(:organizer)              { create(:organizer) }
    let!(:participant_organizer) { create(:participant_organizer, organizer: organizer) }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(admin.api_key)
        }
      end

      it 'removes participant_organizer' do
        expect { request }.to change { ParticipantOrganizer.count }.by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
