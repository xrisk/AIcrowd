require 'rails_helper'

describe NotificationService do
  let!(:participant) { create :participant }
  let!(:challenge) { create(:challenge, :running) }
  let!(:challenge_round) { create(:challenge_round) }

  context 'submission notification' do
    subject { described_class.new(submission.participant_id, submission, submission.grading_status_cd) }

    describe 'submission status graded' do
      let!(:submission) { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'graded') }

      it 'create notification' do
        expect do
          subject.call
        end.to change(Notification, :count).by(1)
      end
    end

    describe 'submission status failed' do
      let!(:submission) { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'failed') }

      it 'create notification' do
        expect do
          subject.call
        end.to change(Notification, :count).by(1)
      end
    end

    describe 'submission status ready' do
      let!(:submission) { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'ready') }

      it 'should not create notification' do
        expect do
          subject.call
        end.to change(Notification, :count).by(0)
      end
    end
  end

  context 'leaderboard notification' do
    subject { described_class.new(leaderboard.participant.id, leaderboard, 'leaderboard') }

    describe 'leaderboard' do
      let!(:leaderboard) { create(:base_leaderboard, challenge: challenge, challenge_round: challenge_round, participant: participant) }

      it 'create notification' do
        expect do
          subject.call
        end.to change(Notification, :count).by(1)
      end
    end
  end
end
