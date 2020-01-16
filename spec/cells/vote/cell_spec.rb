require 'rails_helper'

describe Vote::Cell, type: :cell do
  subject { cell(described_class, blog, current_participant: participant) }

  let(:blog)        { create(:blog) }
  let(:participant) { create(:participant) }

  describe 'cell can be instantiated' do
    it { expect(subject).to be_a described_class }
  end
end
