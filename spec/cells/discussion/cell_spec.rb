require 'rails_helper'

describe Discussion::Cell, type: :cell do
  subject { cell(described_class, topic, current_participant: participant) }

  let!(:topic)       { create(:topic) }
  let!(:participant) { create(:participant) }

  describe 'cell can be instantiated' do
    it { expect(subject).to be_a described_class }
  end
end
