require 'rails_helper'

describe Api::Discourse::WebhooksController, type: :request do
  describe '#create' do
    before do
      stub_const 'ENV', {
        'DISCOURSE_WEBHOOKS_USERNAME' => 'discourse_username',
        'DISCOURSE_WEBHOOKS_API_KEY'  => 'discourse_api_key'
      }
    end

    context 'when authentication params not provided' do
      it 'returns unauthorized status' do
        post api_discourse_webhooks_path

        expect(response).to have_http_status :unauthorized
        expect(response.message).to eq 'Unauthorized'
      end
    end

    context 'when authentication params provided' do
      it 'returns success' do
        post api_discourse_webhooks_path(username: 'discourse_username', api_key: 'discourse_api_key')

        expect(response).to have_http_status :ok
      end
    end
  end
end
