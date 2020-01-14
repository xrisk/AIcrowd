require 'rails_helper'

describe ParticipantClefTask::Cell, type: :cell do
  subject { cell(described_class, clef_task, current_participant: participant) }

  let(:clef_task)   { create(:clef_task) }
  let(:participant) { create(:participant) }

  describe 'cell can be instantiated' do
    it { expect(subject).to be_a ParticipantClefTask::Cell }
  end

  describe '#profile_incomplete?' do
    context 'complete' do
      let(:participant) { create(:participant, :clef_complete) }

      it { expect(subject.profile_incomplete?).to be false }
    end

    context 'incomplete' do
      let(:participant) { create(:participant, :clef_incomplete) }

      it { expect(subject.profile_incomplete?).to be true }
    end
  end

  describe '#eua_required?' do
    context 'required' do
      let(:clef_task) { create(:clef_task, :with_eua) }

      it { expect(clef_task.eua_file.file).to_not be_nil }
      it { expect(subject.eua_required?).to be true }
    end

    context 'not required' do
      it { expect(subject.eua_required?).to be false }
    end
  end

  describe '#participant_status' do
    let(:clef_task) { create(:clef_task, :with_eua) }

    context 'profile_incomplete' do
      let(:participant) { create(:participant, :clef_incomplete) }

      it { expect(subject.participant_status).to eq('profile_incomplete') }
    end

    context 'unregistered' do
      let(:participant) { create(:participant, :clef_complete) }

      it { expect(subject.participant_status).to eq('unregistered') }
    end
  end
end
