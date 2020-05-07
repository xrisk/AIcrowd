require 'rails_helper'

describe Participants::ActivityQuery, type: :query do
  subject { described_class.new(participant: participant).call }

  let(:participant)       { create(:participant) }
  let!(:submission)       { create(:submission, participant: participant, created_at: Time.current) }
  let!(:ahoy_visits)      { create_list(:ahoy_visit, 3, user: participant, started_at: Time.current) }
  let!(:other_ahoy_visit) { create(:ahoy_visit, started_at: Time.current) }

  describe '#call' do
    it 'returns collection of dates and values' do
      activity = subject.find { |activity| activity[:date] == Time.current.to_date }

      expect(activity[:val]).to eq 13
    end
  end
end
