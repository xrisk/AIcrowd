require 'rails_helper'

describe Participants::ActivityHeatmapService do
  subject { described_class.new(participant: participant) }

  let!(:submission)       { create(:submission, participant: participant, created_at: Time.current) }
  let!(:ahoy_visits)      { create_list(:ahoy_visit, 3, user: participant, started_at: Time.current) }
  let!(:other_ahoy_visit) { create(:ahoy_visit, started_at: Time.current) }

  describe '#call' do
    context 'when participant exists in Gitlab' do
      let(:participant) { create(:participant, name: 'test') }

      it 'returns collection of dates and values' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/success') do
          subject.call
        end

        expect(result).to be_success

        activity = result.value.find { |activity| activity[:date] == Time.current.to_date }

        expect(activity[:val]).to eq 13
        expect(activity[:visits]).to eq 3
        expect(activity[:submissions]).to eq 1
        expect(activity[:gitlab_contributions]).to eq 0
      end
    end

    context 'when participant does not exist in Gitlab' do
      let(:participant) { create(:participant, name: 'not_existing_name') }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/failure') do
          subject.call
        end

        expect(result).to be_success

        activity = result.value.find { |activity| activity[:date] == Time.current.to_date }

        expect(activity[:val]).to eq 13
        expect(activity[:visits]).to eq 3
        expect(activity[:submissions]).to eq 1
        expect(activity[:gitlab_contributions]).to eq 0
      end
    end
  end
end
