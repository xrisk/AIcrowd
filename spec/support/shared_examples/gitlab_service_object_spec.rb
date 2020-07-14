shared_examples 'Gitlab ServiceObject class' do
  context 'when Gitlab ENV variables are missing' do
    before { ENV.stub(:[]).with('GITLAB_API_KEY').and_return('') }

    it 'returns failure' do
      result = subject.call

      expect(result.success?).to eq false
      expect(result.value).to eq 'Gitlab API client couldn\'t be properly initialized.'
    end
  end

  context 'when Gitlab API is unavailable' do
    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Gitlab::Error)
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_raise(Gitlab::Error)
      allow_any_instance_of(Faraday::Connection).to receive(:put).and_raise(Gitlab::Error)
      allow_any_instance_of(Faraday::Connection).to receive(:delete).and_raise(Gitlab::Error)
    end

    it 'returns failure' do
      result = subject.call

      expect(result.success?).to eq false
      expect(result.value).to eq 'Gitlab::Error'
    end
  end
end
