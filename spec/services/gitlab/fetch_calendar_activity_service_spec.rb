require 'rails_helper'

describe Gitlab::FetchCalendarActivityService do
  subject { described_class.new(participant: participant) }

  describe '#call' do
    context 'when participant exists in Gitlab' do
      let(:participant) { create(:participant, name: 'shivam') }

      it 'returns success with activity data' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/success') do
          subject.call
        end

        expect(result).to be_success

        activity_data = result.value

        expect(activity_data.size).to eq 32
        expect(activity_data.first).to eq ['2020-06-09', 7]
      end
    end

    context 'when participant does not exist in Gitlab' do
      let(:participant) { create(:participant, name: 'not_existing_name') }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/failure') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
