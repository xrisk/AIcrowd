require 'rails_helper'

describe Leaderboards::CSVExportService do
  subject { described_class.new(leaderboards: BaseLeaderboard.all) }

  let!(:leaderboards)       { create_list(:base_leaderboard, 3) }
  let!(:first_leaderboard)  { create(:base_leaderboard, meta: { first_key: 'first_key', second_key: 'second_key' }) }
  let!(:second_leaderboard) { create(:base_leaderboard, meta: { second_key: 'second_key' }) }

  describe '#call' do
    it 'returns CSV file object' do
      result = subject.call

      expect(result.success?).to eq true

      csv_data = CSV.parse(result.value)

      expect(csv_data.size).to eq 6
      expect(csv_data[0][0]).to eq 'Rank'
      expect(csv_data[1][0]).to eq '1'
    end
  end
end
