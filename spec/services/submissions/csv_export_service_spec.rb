require 'rails_helper'

describe Submissions::CSVExportService do
  subject { described_class.new(submissions: Submission.all) }

  let!(:participant) { create(:participant, name: 'Jhon') }
  let!(:submissions) { create_list(:submission, 3, participant: participant) }

  describe '#call' do
    it 'returns CSV data' do
      result = subject.call

      expect(result.success?).to eq true

      csv_data = CSV.parse(result.value)

      expect(csv_data.size).to eq 4
      expect(csv_data[0][1]).to eq 'Participant'
      expect(csv_data[1][1]).to eq 'Jhon'
    end
  end
end
