require 'rails_helper'

describe DefaultScopeByRoleQuery, type: :query do
  subject do
    described_class.new(
      participant:     participant,
      participant_sql: participant_sql,
      relation:        BaseLeaderboard
    ).call
  end

  describe '#call' do
    let!(:leaderboard)             { create(:base_leaderboard) }
    let!(:organizer_leaderboard)   { create(:base_leaderboard, challenge: challenge) }
    let!(:participant_leaderboard) { create(:base_leaderboard, submitter: participant) }
    let(:participant_sql)          { "submitter_type = 'Participant' AND submitter_id = #{participant.id}" }
    let(:organizer)                { create(:organizer) }
    let(:challenge)                { create(:challenge, organizers: [organizer]) }

    context 'when admin provided in params' do
      let(:participant) { create(:participant, :admin) }

      it 'returns all leaderboards' do
        expect(subject).to contain_exactly(leaderboard, organizer_leaderboard, participant_leaderboard)
      end
    end

    context 'when organizer provided in params' do
      let(:participant) { create(:participant, organizers: [organizer]) }

      it 'returns leaderboards from participant_sql + organizer leaderboards' do
        expect(subject).to contain_exactly(organizer_leaderboard, participant_leaderboard)
      end
    end

    context 'when participant provided in params' do
      let(:participant) { create(:participant) }

      it 'returns leaderboards based only on participant_sql' do
        expect(subject).to eq [participant_leaderboard]
      end
    end
  end
end
