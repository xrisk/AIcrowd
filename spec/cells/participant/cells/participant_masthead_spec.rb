require 'rails_helper'

describe Participant::Cell::ParticipantMasthead, type: :cell do
  subject { cell(described_class, participant, current_participant: current_participant) }

  let!(:participant)         { create(:participant) }
  let!(:current_participant) { create(:participant) }

  describe 'cell can be instantiated' do
    it { expect(subject).to be_a described_class }
  end
end
