require 'rails_helper'

describe Api::V1::Challenges::DatasetFilesController, type: :request do
  let!(:challenge)   { create(:challenge, :running) }
  let!(:participant) { create(:participant, :admin) }
  let(:params) do
    {
      title:       'Dataset File Title',
      description: 'Dataset File Description'
    }
  end

  describe '#create' do
    let(:request) { post api_v1_challenge_dataset_files_path(challenge), headers: headers, params: params }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'creates new dataset_file' do
        expect { request }.to change { DatasetFile.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq 'Dataset File Title'
      end
    end
  end

  describe '#update' do
    let!(:dataset_file) { create(:dataset_file, title: 'Old Title', challenge: challenge) }
    let(:request)       { patch api_v1_challenge_dataset_file_path(challenge, dataset_file), headers: headers, params: params }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'updates dataset_file' do
        request

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq 'Dataset File Title'
      end
    end
  end

  describe '#destroy' do
    let!(:dataset_file) { create(:dataset_file, title: 'Old Title', challenge: challenge) }
    let(:request)       { delete api_v1_challenge_dataset_file_path(challenge, dataset_file), headers: headers }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'creates new dataset_file' do
        expect { request }.to change { DatasetFile.count }.by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
