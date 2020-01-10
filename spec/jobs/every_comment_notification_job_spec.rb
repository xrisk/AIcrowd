require 'rails_helper'

RSpec.describe EveryCommentNotificationJob, type: :job, api: true do
  include ActiveJob::TestHelper

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe 'receive_every_email' do
    let!(:participant) { create :participant }
    let!(:email_preference) do
      create :email_preference,
             email_frequency: :every,
             participant:     participant
    end
    let!(:topic) { create :topic, participant: participant }
    let!(:comment) { create :comment, topic: topic, participant: participant }

    subject(:job) { described_class.perform_later(comment.id) }

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
      expect do
        perform_enqueued_jobs { job }
      end.to change(MandrillMessage, :count).by(1)
    end

    it 'is sent by Mandrill' do
      perform_enqueued_jobs { job }
      man = MandrillMessage.last
      expect(man.status).to eq('sent')
    end
  end

  describe 'daily_digest' do
    let!(:participant) { create :participant }
    let!(:email_preference) do
      create :email_preference,
             email_frequency: :daily,
             participant:     participant
    end
    let!(:topic) { create :topic, participant: participant }
    let!(:comment) { create :comment, topic: topic, participant: participant }

    subject(:job) { described_class.perform_later(comment.id) }

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
    let!(:participant) { create :participant }
    let!(:email_preference) do
      create :email_preference,
             email_frequency: :weekly,
             participant:     participant
    end
    let!(:topic) { create :topic, participant: participant }
    let!(:comment) { create :comment, topic: topic, participant: participant }

    subject(:job) { described_class.perform_later(comment.id) }

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
end
