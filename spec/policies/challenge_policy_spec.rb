require 'rails_helper'

describe ChallengePolicy do
  context 'for a published Challenge' do
    subject { described_class.new(participant, challenge) }

    let(:challenge)             { create(:challenge, organizers: [organizer]) }
    let(:organizer)             { create(:organizer) }
    let(:organizer_person)      { create(:participant) }
    let(:participant_organizer) { create(:participant_organizer, participant: organizer_person, organizer: organizer) }
    let(:admin)                 { create(:participant, :admin) }

    context 'for a public participant' do
      let(:participant) { nil }
      # it { is_expected.to permit_action(:show) }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to forbid_action(:create) }
      it { is_expected.to forbid_action(:new) }
      it { is_expected.to forbid_action(:update) }
      it { is_expected.to forbid_action(:edit) }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'for the organizer' do
      let(:participant) { participant_organizer.participant }
      # it { is_expected.to permit_action(:show) }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'for an admin' do
      let(:participant) { admin }
      # it { is_expected.to permit_action(:show) }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  context 'for a private challenge' do
    # subject { described_class.new(participant, challenge) }
  end
end
