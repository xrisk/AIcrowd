require 'rails_helper'

RSpec.describe EveryTopicNotificationJob, type: :job do
  include ActiveJob::TestHelper

  describe 'receive_every_email' do
    let!(:author) { create :participant }
    let!(:follower) { create :participant }
    let!(:email_preference) {
      create :email_preference,
      email_frequency: :every,
      participant: follower }
    let!(:follow) { create :follow, participant: follower }
    let!(:topic) {
      create :topic,
      challenge_id: follow.followable_id,
      participant: author }
    subject(:job) { described_class.perform_later(topic.id) }

    it 'queues the job' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'is placed on the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end

    it 'executes with no errors' do
      perform_enqueued_jobs { job }
    end

    it 'writes to the email log' do
      expect {
        perform_enqueued_jobs { job }
      }.to change(MandrillMessage, :count).by(1)
    end

    it 'is sent by Mandrill' do
      perform_enqueued_jobs { job }
      man = MandrillMessage.last
      ### NATE: current workaround for mandrill tests
      ### are to check that the reason the message
      ### wasn't sent was due to it being unsigned.  The
      ### mandrill test api key is on a separate account
      ### and would need more setup to be able to send.
      # expect(man.status).to eq('sent')
      expect(man.status).to eq('rejected')
      expect(man.reject_reason).to eq('unsigned')
    end
  end

  describe 'daily_digest' do
    let!(:author) { create :participant }
    let!(:follower) { create :participant }
    let!(:email_preference) {
      create :email_preference,
      email_frequency: :daily,
      participant: follower }
    let!(:topic) { create :topic, participant: author }
    subject(:job) { described_class.perform_later(topic.id) }

    it 'queues the job' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'is placed on the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end

    it 'executes with no errors' do
      perform_enqueued_jobs { job }
    end

    it 'is not sent by Mandrill' do
      perform_enqueued_jobs { job }
      expect(MandrillMessage.count).to eq(0)
    end
  end

  describe 'weekly digest' do
    let!(:author) { create :participant }
    let!(:follower) { create :participant }
    let!(:email_preference) {
      create :email_preference,
      email_frequency: :weekly,
      participant: follower }
    let!(:topic) { create :topic, participant: author }
    subject(:job) { described_class.perform_later(topic.id) }

    it 'queues the job' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'is placed on the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end

    it 'executes with no errors' do
      perform_enqueued_jobs { job }
    end

    it 'is not sent by Mandrill' do
      perform_enqueued_jobs { job }
      expect(MandrillMessage.count).to eq(0)
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

end
