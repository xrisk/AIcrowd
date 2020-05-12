require 'rails_helper'

describe IntercomService do
  let!(:participant) { create :participant }

  describe '#call' do
    context 'with no event name'  do
      it 'returns raises exception of Intercom' do
        VCR.use_cassette('intercom_service/with_no_event_name') do
          expect { IntercomService.new('', participant).call }.to raise_exception Intercom::UnexpectedError
        end
      end
    end

    context 'with a participant not a contact of intercom' do
      it 'returns null with not a contact of intercom'do
        VCR.use_cassette('intercom_service/with_participant_not_contact') do
          expect(IntercomService.new('test_event', participant, {}).call).to eq nil
        end
      end
    end

    context 'with a right event name' do
      it 'returns null with right event name' do
        VCR.use_cassette('intercom_service/with_right_event_name') do
          expect(IntercomService.new('test_event', participant, {}).call).to eq nil
        end
      end
    end

    context 'with no participant' do
      it 'returns null with right event name' do
        VCR.use_cassette('intercom_service/with_no_participant') do
          expect(IntercomService.new('test_event', nil, {}).call).to eq nil
        end
      end
    end

    context 'with a participant not having email' do
      it 'returns null with right event name' do
        VCR.use_cassette('intercom_service/with_participant_not_having_email') do
          expect(IntercomService.new('test_event', participant, {}).call).to eq nil
        end
      end
    end

    context 'with metadata has a hash' do
      it 'returns null with right event name' do
        VCR.use_cassette('intercom_service/with_non_hash_metadata') do
          expect(IntercomService.new('test_event', participant, 'sht').call).to eq nil
        end
      end
    end
  end
end
