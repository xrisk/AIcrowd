require 'rails_helper'

describe Submissions::CSVExportService do

  let!(:participant)     { create(:participant, name: 'Jhon') }
  let!(:challenge_round) { create(:challenge_round, score_title: 'Test Title', score_secondary_title: 'Test Secondary Title') }
  let!(:submissions)     { create_list(:submission, 3, :with_meta, :with_file, participant: participant, challenge_round: challenge_round, ) }

  describe '#call' do
    it 'returns CSV data with no downloadable s3 links' do
      result = described_class.new(submissions: Submission.all).call

      expect(result.success?).to eq true
      csv_data = CSV.parse(result.value)
      expect(csv_data.size).to eq 7
      expect(csv_data[0][1]).to eq 'Type'
      expect(csv_data[0][3]).to eq 'Participants'
      expect(csv_data[1][1]).to eq 'Participant'
      expect(csv_data[0][-1]).not_to eq 'Download Links'

    end

    it 'returns CSV data with downloadable s3 links' do
      result = described_class.new(submissions: Submission.all, downloadable:true).call

      expect(result.success?).to eq true
      csv_data = CSV.parse(result.value)
      expect(csv_data.size).to eq 7
      expect(csv_data[0][1]).to eq 'Type'
      expect(csv_data[0][3]).to eq 'Participants'
      expect(csv_data[1][1]).to eq 'Participant'
      expect(csv_data[0][-1]).to eq 'Download Links'
      link  = csv_data[2][-1].split('/')[4]
      expect(link).to eq 'submissions'
    end
  end
end
