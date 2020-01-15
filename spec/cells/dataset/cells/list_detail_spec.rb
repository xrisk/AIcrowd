require 'rails_helper'

describe Dataset::Cell::ListDetail, type: :cell do
  subject { cell(described_class, current_participant: participant) }

  let(:participant) { create(:participant) }

  describe 'cell can be instantiated' do
    it { expect(subject).to be_a described_class }
  end
end
