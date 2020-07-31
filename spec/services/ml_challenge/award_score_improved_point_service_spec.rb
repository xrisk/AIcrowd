require 'rails_helper'

describe MlChallenge::AwardScoreImprovedPointService do
  let!(:challenge)       { create(:challenge, :running) }
  let!(:challenge_round) { create(:challenge_round, challenge: challenge) }
  let!(:activity_point)  { create(:activity_point, activity_key: 'score_improved_over_5_times') }

  describe 'create MlActivityPoint' do
    context 'Create Award point for improve score in a day' do
      let(:participant)      { create(:participant) }
      let!(:submission1)     { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'graded', challenge_round_id: challenge_round.id, score: 0.7) }
      let!(:submission2)     { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'graded', challenge_round_id: challenge_round.id, score: 0.9) }
      let!(:submission3)     { create(:submission, challenge: challenge, participant: participant, grading_status_cd: 'graded', challenge_round_id: challenge_round.id, score: 1.3) }
      let!(:leaderboard)     { create(:base_leaderboard, challenge: challenge, challenge_round_id: challenge_round.id, submitter: participant) }

      subject { described_class.new(submission3, 'score_improved_over_5_times') }

      it 'create ml_activity_points record' do
        subject.call
        expect(MlActivityPoint.count).to eq(1)
      end
    end

    context 'Award point for improve score in a day' do
      let(:participant2)     { create(:participant) }
      let!(:submission4)     { create(:submission, challenge: challenge, participant: participant2, grading_status_cd: 'graded', challenge_round_id: challenge_round.id, score: 1.5) }
      let!(:submission5)     { create(:submission, challenge: challenge, participant: participant2, grading_status_cd: 'graded', challenge_round_id: challenge_round.id, score: 0.5) }
      let!(:submission6)     { create(:submission, challenge: challenge, participant: participant2, grading_status_cd: 'graded', challenge_round_id: challenge_round.id, score: 0.8) }
      let!(:leaderboard)     { create(:base_leaderboard, challenge: challenge, challenge_round_id: challenge_round.id, submitter: participant2) }

      subject { described_class.new(submission6, 'score_improved_over_5_times') }

      it 'not create ml_activity_points record for not increasing/improving score' do
        subject.call
        expect(MlActivityPoint.count).to eq(0)
      end
    end
  end
end
