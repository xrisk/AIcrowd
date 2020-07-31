# frozen_string_literal: true

require 'rails_helper'

describe ParticipantPolicy do
  subject { described_class.new(user, participant) }

  let(:participant)                 { create(:participant) }
  let(:admin)                       { create(:participant, :admin) }
  let(:organizer_participant)       { create(:participant) }
  let(:organizer)                   { create(:organizer) }
  let(:participant_organizer)       { create(:participant_organizer, participant: organizer_participant, organizer: organizer) }
  let(:clef_participant)            { create(:participant) }
  let(:clef_organizer)              { create(:organizer, :clef) }
  let(:participant_clef_organizer)  { create(:participant_organizer, participant: clef_participant, organizer: clef_organizer) }

  context 'for a public participant' do
    let(:user) { nil }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:regen_api_key) }
  end

  context 'for the participant themself' do
    let(:user) { participant }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:regen_api_key) }
  end

  context 'for an admin' do
    let(:user) { admin }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:regen_api_key) }
  end

  context 'for an organizer' do
    let(:user) { participant_organizer.participant }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:regen_api_key) }
  end

  context 'for an CLEF organizer' do
    let(:user) { participant_clef_organizer.participant }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action(:regen_api_key) }
  end
end
