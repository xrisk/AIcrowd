require 'rails_helper'

describe Api::V1::Challenges::DatasetFoldersController, type: :request do
  let!(:challenge)   { create(:challenge, :running) }
  let!(:participant) { create(:participant, :admin) }
  let(:params) do
    {
      title:          'Dataset File Title',
      description:    'Dataset File Description',
      directory_path: 'folder_name',
      aws_access_key: 'REDACTED',
      aws_secret_key: 'REDACTED',
      bucket_name:    'bucket_name',
      region:         'eu-north-1'
    }
  end

  describe '#create' do
    let(:request) { post api_v1_challenge_dataset_folders_path(challenge), headers: headers, params: params }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'creates new dataset_folder' do
        expect { request }.to change { DatasetFolder.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq 'Dataset File Title'
      end
    end
  end

  describe '#update' do
    let!(:dataset_folder) { create(:dataset_folder, title: 'Old Title', challenge: challenge) }
    let(:request)         { patch api_v1_challenge_dataset_folder_path(challenge, dataset_folder), headers: headers, params: params }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'updates dataset_folder' do
        request

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq 'Dataset File Title'
      end
    end
  end

  describe '#destroy' do
    let!(:dataset_folder) { create(:dataset_folder, title: 'Old Title', challenge: challenge) }
    let(:request)         { delete api_v1_challenge_dataset_folder_path(challenge, dataset_folder), headers: headers }

    it_behaves_like 'Api::V1 endpoint with Authentication'

    context 'when authenticity token provided' do
      let(:headers) do
        {
          'Authorization': auth_header(participant.api_key)
        }
      end

      it 'creates new dataset_folder' do
        expect { request }.to change { DatasetFolder.count }.by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
