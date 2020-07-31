require 'rails_helper'

describe Gitlab::FetchCalendarActivityService do
  subject { described_class.new(participant: participant) }

  describe '#call' do
    let(:participant) { create(:participant) }

    it_behaves_like 'Gitlab ServiceObject class'

    context 'when participant exists in Gitlab' do
      let(:participant) { create(:participant, name: 'test') }

      it 'returns success with activity data' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/success') do
          subject.call
        end

        expect(result).to be_success

        activity_data = result.value

        expect(activity_data.size).to eq 32
        expect(activity_data.first).to eq [Date.parse('2020-06-09'), 7]
      end
    end

    context 'when Gitlab redirects request to correct username' do
      let(:participant) { create(:participant, name: 'Parilo') }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/redirect') do
          subject.call
        end

        expect(result).to be_success
      end
    end

    context 'when participant Gitlab page returns unauthorized error' do
      let(:participant) { create(:participant, name: 'not_existing_name') }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/unauthorized') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq '{"error"=>"You need to sign in or sign up before continuing."}'
      end
    end

    context 'when participant Gitlab page returns not_found error' do
      let(:participant) { create(:participant, name: 'not_found') }

      it 'returns failure with error message' do
        result = VCR.use_cassette('gitlab_api/fetch_calendar_activity/not_found') do
          subject.call
        end

        expect(result).to be_failure
        expect(result.value).to eq 'A JSON text must at least contain two octets!'
      end
    end
  end
end
