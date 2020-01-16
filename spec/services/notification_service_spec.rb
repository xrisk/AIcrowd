require 'rails_helper'

describe NotificationService do
  let!(:participant) { create(:participant) }

  context 'topic' do
    let!(:topic) { create(:topic) }

    it 'creates a notification' do
      expect do
        described_class.new(participant.id, topic, 'topic').call
      end.to change(Notification, :count).by(1)
    end
  end
end
