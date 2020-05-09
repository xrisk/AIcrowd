require 'rails_helper'

RSpec.describe IntercomService do
  let!(:participant) { create :participant }

  describe '#initialize' do
    ENV['INTERCOM_TOKEN'] = 'TEST_TOKEN'
    subject { described_class.new }

    it { expect(subject).to be_a described_class }
    it { expect(subject.instance_variable_get(:@client)).to be_a Intercom::Client }
  end

  describe '#call' do
    before(:context) do
      Intercom::Client.contacts.create(email: participant.email, role: "user")
    end
    context 'with a null token' do
      ENV["INTERCOM_TOKEN"] = nil
      subject { described_class.new }
      it { expect(subject).to raise_exception Intercom::MisconfiguredClientError }
    end
    context 'with no event name' do
      subject { described_class.new.call('', participant, {}) }
      it { expect(subject).to raise_exception Intercom::IntercomError }
    end
    context 'with a right event name' do
      subject { described_class.new.call('test_event', participant, {}) }
      it { expect(subject).to be_a nil }
    end
    context 'with a participant not a contact of intercom' do
      subject { described_class.new.call('test_event', participant, {}) }
      it { expect(subject).to be_a nil }
    end
    context 'with no participant' do
      subject { described_class.new.call('test_event', nil, {}) }
      it { expect(subject).to be_a nil }
    end
    context 'with a participant not having email' do
      subject { described_class.new.call('test_event', participant, {}) }
      it { expect(subject).to be_a nil }
    end
    context 'with metadata has a hash' do
      subject { described_class.new.call('test_event', participant, 'sht') }
      it { expect(subject).to be_a nil }
    end
  end
end
