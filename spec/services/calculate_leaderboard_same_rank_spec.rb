require 'rails_helper'

describe CalculateLeaderboardService do
  before do
    Timecop.freeze(
      DateTime.new(2018, 0o3, 15, 9, 0, 0, "+02:00"),
      nsec: 0)
  end

  after do
    Timecop.return
  end

  #  Sub  | Part | Score     | Secondary | Post? | Window  | Ago | Baseline
  # ------|------|-----------|-------------------|---------|-----| --------
  #  p1s1 |  p1  | 30.050123 | 0.001999  |  No   | Prev    | 52h |  No
  #  p2s1 |  p2  | 29.00     | 0.003     |  No   | Prev    | 70h |  No
  #  p2s2 |  p2  | 36.00     | 0.003     |  No   | Current |  5h |  No
  #  p3s1 |  p4  | 36.00     | 0.003     |  No   | Current |  10h |  No

  let!(:challenge) { create :challenge, :running }
  let!(:challenge_round) { challenge.challenge_rounds.first }
  # Ranking Window = 48 hours
  let!(:participant1) { create :participant }
  let!(:participant2) { create :participant }
  let!(:participant3) { create :participant }
  let!(:p1s1) do
    create :submission,
           participant:        participant1,
           challenge:          challenge,
           challenge_round_id: challenge_round.id,
           grading_status:     :graded,
           score:              30.050123,
           score_secondary:    0.001999,
           created_at:         52.hours.ago
  end
  let!(:p2s1) do
    create :submission,
           participant:        participant2,
           challenge:          challenge,
           challenge_round_id: challenge_round.id,
           grading_status:     :graded,
           score:              29.00,
           score_secondary:    0.003,
           created_at:         70.hours.ago
  end
  let!(:p2s2) do
    create :submission,
           participant:        participant2,
           challenge:          challenge,
           challenge_round_id: challenge_round.id,
           grading_status:     :graded,
           score:              36.00,
           score_secondary:    0.003,
           created_at:         5.hours.ago
  end
  let!(:p3s1) do
    create :submission,
           participant:        participant3,
           challenge:          challenge,
           challenge_round_id: challenge_round.id,
           grading_status:     :graded,
           score:              36.00,
           score_secondary:    0.003,
           created_at:         6.hours.ago
  end

  describe 'tie ranking cases' do
    # Leaderboard
    # Row | Submission | Part | Primary | Secondary | Entries
    # ----|------------|------|---------|-----------|---------
    #  1  |  p3s1      |  p4  |  36.00  |  0.003    |    1
    #  1  |  p2s2      |  p2  |  36.00  |  0.003    |    2
    #  3  |  p1s1      |  p1  |  30.05  |  0.002    |    1

    # Previous Leaderboard
    # Row | Submission | Part | Primary | Secondary | Entries
    # ----|------------|------|---------|-----------|---------
    #  1  |  p1s1      |  p1  |  30.05  |  0.002    |    1
    #  2  |  p2s1      |  p2  |  29.00  |  0.003    |    1
    before do
      challenge_round.update!(primary_sort_order: :descending, secondary_sort_order: :descending)
      described_class.new(challenge_round_id: challenge_round.id).call
      p1s1.reload
      p2s1.reload
      p2s2.reload
      p3s1.reload
    end

    # leaderboard
    it {
      expect(Leaderboard.first.submitter)
          .to eq(participant2).or eq(participant3)
    }

    it {
      expect(Leaderboard.second.submitter)
          .to eq(participant2).or eq(participant3)
    }

    it {
      expect(Leaderboard.third.submitter)
          .to eq(participant1)
    }

    it {
      expect(Leaderboard.first.row_num)
          .to eq(1)
    }

    it {
      expect(Leaderboard.second.row_num)
          .to eq(1)
    }

    it {
      expect(Leaderboard.third.row_num)
          .to eq(3)
    }
  end
end
