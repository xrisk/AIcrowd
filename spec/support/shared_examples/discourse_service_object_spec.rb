shared_examples 'Discourse ServiceObject class' do
  context 'when discourse ENV variables are missing' do
    before do
      ENV.stub(:[]).with('DISCOURSE_DOMAIN_NAME').and_return('')
      ENV.stub(:[]).with('DISCOURSE_API_USERNAME').and_return('')
    end

    it 'returns failure' do
      result = subject.call

      expect(result.success?).to eq false
      expect(result.value).to eq 'Discourse API client couldn\'t be properly initialized.'
    end
  end

  context 'when discourse API is unavailable' do
    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Discourse::Error)
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_raise(Discourse::Error)
      allow_any_instance_of(Faraday::Connection).to receive(:put).and_raise(Discourse::Error)
      allow_any_instance_of(Faraday::Connection).to receive(:delete).and_raise(Discourse::Error)
    end

    it 'returns failure' do
      result = subject.call

      expect(result.success?).to eq false
      expect(result.value).to eq 'Discourse::Error'
    end
  end
end
