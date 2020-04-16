shared_examples 'Api::V1 endpoint with Authentication' do
  context 'when participant is not logged in' do
    it 'allows only authenticated requests' do
      request

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
