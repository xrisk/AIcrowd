require 'rails_helper'

describe Leaderboards::FilterService do
  subject { described_class.new(leaderboards: BaseLeaderboard.all, params: params) }

  let!(:participant1) { create(:participant, country_cd: 'IN', affiliation: 'testing1') }
  let!(:participant2) { create(:participant, country_cd: 'AU', affiliation: 'testing3') }
  let!(:leaderboard1) { create(:base_leaderboard, submitter: participant1) }
  let!(:leaderboard2) { create(:base_leaderboard, submitter: participant2) }
  let!(:participants) { create_list(:participant, 3, country_cd: 'IN', affiliation: 'testing1') }
  let!(:team) { create(:team, participants: participants) }
  let!(:leaderboard3) { create(:base_leaderboard, submitter: team) }

  let(:params) { ActionController::Parameters.new(country_cd: 'IN', affiliation: 'testing1') }

  describe '#call' do
    context 'filter by leaderboard ids' do
      it 'return filtered leaderboard ids as per params' do
        result = subject.call('leaderboard_ids')
        expect(result).to eq([leaderboard3.id, leaderboard1.id])
      end
    end

    context 'filter by participant affiliations' do
      it 'return filtered participant affiliations' do
        result = subject.call('participant_affiliations')
        expect(result.first).to eq(participant1.affiliation)
      end
    end

    context 'filter by participant countries' do
      it 'return filtered participant countries' do
        result = subject.call('participant_countries')
        expect(result.first).to eq(Participant.country_name(participant1.country_cd))
      end
    end
  end
end
