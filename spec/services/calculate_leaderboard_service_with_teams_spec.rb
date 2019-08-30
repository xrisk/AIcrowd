require 'rails_helper'

RSpec.describe CalculateLeaderboardService do
  # challenge
  let(:challenge) { create :challenge, :running, primary_sort_order: :descending }
  let(:challenge_round) { challenge.challenge_rounds.first }
  # participants
  let!(:p1_in_t1) { create :participant }
  let!(:p2_in_t1) { create :participant }
  let!(:p3_in_t2) { create :participant }
  let!(:p4_solo) { create :participant }
  # teams
  let!(:team1) { create :team, challenge: challenge, participants: [p1_in_t1, p2_in_t1] }
  let!(:team2) { create :team, challenge: challenge, participants: [p3_in_t2] }
  # submissions
  let!(:p1s1) { create(:submission,
    participant: p1_in_t1,
    challenge: challenge,
    challenge_round_id: challenge_round.id,
    grading_status: :graded,
    score: 30,
    created_at: 50.hours.ago,
  ) }
  let!(:p2s1) { create(:submission,
    participant: p2_in_t1,
    challenge: challenge,
    challenge_round_id: challenge_round.id,
    grading_status: :graded,
    score: 40,
    created_at: 50.hours.ago,
  ) }
  let!(:p3s1) { create(:submission,
    participant: p3_in_t2,
    challenge: challenge,
    challenge_round_id: challenge_round.id,
    grading_status: :graded,
    score: 20,
    created_at: 50.hours.ago,
  ) }
  let!(:p4s1) { create(:submission,
    participant: p4_solo,
    challenge: challenge,
    challenge_round_id: challenge_round.id,
    grading_status: :graded,
    score: 10,
    created_at: 50.hours.ago,
  ) }
  let!(:p4s2) { create(:submission,
    participant: p4_solo,
    challenge: challenge,
    challenge_round_id: challenge_round.id,
    grading_status: :graded,
    score: 5,
    created_at: 10.hours.ago,
  ) }

  # Leaderboard
  # Row | Submission | Submitter    | Score | Entries
  # ----|------------|--------------|-------|--------
  #  1  |  p2s1      |  team1       |  40   |  2
  #  2  |  p3s1      |  team2       |  20   |  1
  #  3  |  p4s1      |  p4_solo     |  10   |  2


  describe 'supports teams' do
    before do
      described_class.new(challenge_round_id: challenge_round.id).call
    end

    it { expect(Leaderboard.count).to eq(3) }

    it { expect(Leaderboard.first.entries).to eq(2) }
    it { expect(Leaderboard.first.score).to eq(40) }
    it { expect(Leaderboard.first.participant).not_to be }
    it { expect(Leaderboard.first.submitter).to eq(team1) }

    it { expect(Leaderboard.second.participant).not_to be }
    it { expect(Leaderboard.second.submitter).to eq(team2) }
    it { expect(Leaderboard.second.score).to eq(20) }

    it { expect(Leaderboard.third.score).to eq(10) }
    it { expect(Leaderboard.third.submitter).to eq(p4_solo) }
    it { expect(Leaderboard.third.entries).to eq(2) }
  end
end
