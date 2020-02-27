require 'rails_helper'

describe Submissions::CSVExportService do
  subject { described_class.new(submissions: Submission.all) }

  let!(:participant)     { create(:participant, name: 'Jhon') }
  let!(:challenge_round) { create(:challenge_round, score_title: 'Test Title', score_secondary_title: 'Test Secondary Title') }
  let!(:submissions)     { create_list(:submission, 3, participant: participant, challenge_round: challenge_round) }

  describe '#call' do
    it 'returns CSV data' do
      result = subject.call

      expect(result.success?).to eq true

      csv_data = CSV.parse(result.value)

      expect(csv_data.size).to eq 4
      expect(csv_data[0][1]).to eq 'Type'
      expect(csv_data[0][4]).to eq 'Test Title'
      expect(csv_data[0][5]).to eq 'Test Secondary Title'
      expect(csv_data[1][1]).to eq 'Participant'
    end
  end
end
