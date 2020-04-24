require 'rails_helper'

describe Api::V1::ParticipantsController, type: :request do
  let(:participant) { create(:participant) }

  describe '#user_profile' do
    context 'when call for participant' do
      it 'render tooltip of that participant' do
        get user_profile_api_v1_participant_path(participant.id), params: { username: 'true', avatar: 'true' }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
