require 'rails_helper'

describe Api::V1::FeedbacksController, type: :request do
  describe '#create' do
    context 'when participant is logged in' do
      let(:participant) { create(:participant) }

      before { login_as participant }

      it 'render tooltip of that participant' do
        post api_v1_feedbacks_path, params: { message: '<p>Test message</p>' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq '<p>Test message</p>'
      end
    end

    context 'when participant is not logged in' do
      it 'render tooltip of that participant' do
        post api_v1_feedbacks_path, params: { message: '<p>Test message</p>' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq 'Participant must exist'
      end
    end
  end
end
