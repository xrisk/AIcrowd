require 'rails_helper'

describe MlChallenge::AwardPointService do
  let!(:participant)     { create(:participant) }
  let!(:challenge)       { create(:challenge, :running) }
  let!(:challenge_round) { create(:challenge_round) }

  describe 'create MlActivityPoint' do
    context 'Award point for new_challenge_signup_participation' do
      let!(:activity_point)  { create(:activity_point, activity_key: 'new_challenge_signup_participation') }
      let!(:submission)      { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'graded') }

      subject { described_class.new(submission, 'new_challenge_signup_participation') }

      it 'create ml_activity_points record' do
        subject.call
        expect(MlActivityPoint.count).to eq(1)
      end
    end

    context 'Award point for first graded submission' do
      let!(:activity_point)  { create(:activity_point, activity_key: 'first_submission') }
      let!(:submission)      { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'graded') }

      subject { described_class.new(submission, 'first_submission') }

      it 'create ml_activity_points record' do
        subject.call
        expect(MlActivityPoint.count).to eq(1)
      end
    end

    context 'Award point for legendary submission' do
      let!(:activity_point)  { create(:activity_point, activity_key: 'legendary_submission') }
      let!(:leaderboard) { create(:base_leaderboard, submitter: participant) }

      subject { described_class.new(leaderboard, 'legendary_submission') }

      it 'create ml_activity_points record' do
        subject.call
        expect(MlActivityPoint.count).to eq(1)
      end
    end
  end
end
