require 'rails_helper'

describe Api::V1::Challenges::NewsletterEmailsController, type: :request do
  let(:challenge)   { create(:challenge, :running) }
  let(:participant) { create(:participant, :admin) }

  describe '#search' do
    let!(:challenge_round) { create(:challenge_round, challenge: challenge) }

    context 'when query provided in params' do
      it 'returns success' do
        get search_api_v1_challenge_newsletter_emails_path(challenge), { params: { q: 'joe' } }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when query not provided in params' do
      it 'returns success' do
        get search_api_v1_challenge_newsletter_emails_path(challenge)

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#preview' do
    before do
      Organizers::NewsletterEmailMailer.any_instance.stub(:sendmail).and_return(true)
      login_as participant
    end

    context 'when valid params sent in body' do
      let(:valid_params) { { newsletter_email: { subject: 'Test Subject', message: '<p>Test Message</p>' } } }

      it 'returns success and enqueues NewsletterEmailPreviewJob' do
        post preview_api_v1_challenge_newsletter_emails_path(challenge), params: valid_params

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid params sent in body' do
      let(:invalid_params) { { newsletter_email: { subject: '', message: '<p>Test Message</p>' } } }

      it 'returns failure' do
        post preview_api_v1_challenge_newsletter_emails_path(challenge), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq 'Subject can\'t be blank'
      end
    end
  end
end
