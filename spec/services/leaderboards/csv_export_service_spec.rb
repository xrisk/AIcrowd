require 'rails_helper'

describe Leaderboards::CSVExportService do
  subject { described_class.new(leaderboards: BaseLeaderboard.all) }

  let!(:leaderboards)       { create_list(:base_leaderboard, 3) }

  describe '#call' do
    it 'returns CSV data' do
      result = subject.call

      expect(result.success?).to eq true

      csv_data = CSV.parse(result.value)

      expect(csv_data.size).to eq 4
      expect(csv_data[0][0]).to eq 'Rank'
      expect(csv_data[1][0]).to eq '1'
    end
  end
end
