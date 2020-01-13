require 'rails_helper'

describe Leaderboard::Cell, type: :cell do
  subject { cell(described_class, challenge, current_participant: participant) }

  let(:challenge)   { create(:challenge) }
  let(:participant) { create(:participant) }

  describe 'cell can be instantiated' do
    it { expect(subject).to be_a Leaderboard::Cell }
  end
end
