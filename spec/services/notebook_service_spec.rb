require 'rails_helper'

RSpec.describe NotebookService do
  let(:notebook_url) { "https://gitlab.crowdai.org/crowdai-dojo/Selecting-data-in-pandas/raw/master/index.ipynb"}

  describe '#call' do
    subject { described_class.new(notebook_url: notebook_url) }

    it 'returns successfull response from CrowdAI gitlab API' do
      result = VCR.use_cassette('gitlab_crowdai_api/success') do
        subject.call
      end

      expect(result).not_to be_nil
    end
  end
end
