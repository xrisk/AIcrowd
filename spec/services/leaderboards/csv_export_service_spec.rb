require 'rails_helper'

describe Leaderboards::CSVExportService do
  subject { described_class.new(leaderboards: BaseLeaderboard.all) }

  let!(:challenge_leaderboard_extra) { create(:challenge_leaderboard_extra, score_title: 'Test Title', score_secondary_title: 'Test Secondary Title', default: true)}
  let!(:challenge_round) { create(:challenge_round, challenge_leaderboard_extras: [challenge_leaderboard_extra]) }
  let!(:leaderboards)    { create_list(:base_leaderboard, 3, challenge_round: challenge_round) }

  describe '#call' do
    it 'returns CSV data' do
      result = subject.call

      expect(result.success?).to eq true

      csv_data = CSV.parse(result.value)

      expect(csv_data.size).to eq 4
      expect(csv_data[0][0]).to eq 'Rank'
      expect(csv_data[0][5]).to eq 'Test Title'
      expect(csv_data[0][6]).to eq 'Test Secondary Title'
      expect(csv_data[1][0]).to eq '1'
    end
  end
end
