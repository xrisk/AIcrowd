require 'rails_helper'

describe ChallengesHelper do
  describe 'challenge_stat_count(challenge, stat_type, parent_meta_challenge)' do
    context 'when standard challenge passed in parameters' do
      let!(:challenge)              { create(:challenge, :running, page_views: 10, vote_count: 10) }
      let!(:submissions)            { create_list(:submission, 2, challenge: challenge) }
      let!(:challenge_participants) { create_list(:challenge_participant, 2, challenge: challenge) }
      let!(:teams)                  { create_list(:team, 2, challenge: challenge) }

      it 'returns statistics based on standard challenge' do
        expect(challenge_stat_count(challenge, 'view')).to eq 10
        expect(challenge_stat_count(challenge, 'vote')).to eq 10
        expect(challenge_stat_count(challenge, 'submission')).to eq 2
        expect(challenge_stat_count(challenge, 'participant')).to eq 2
        expect(challenge_stat_count(challenge, 'team')).to eq 2
      end
    end

    context 'when meta challenge or problem passed in parameters' do
      let!(:meta_challenge)                        { create(:challenge, :running, :meta_challenge, page_views: 10, vote_count: 10) }
      let!(:meta_challenge_submissions)            { create_list(:submission, 2, challenge: meta_challenge) }
      let!(:meta_challenge_challenge_participants) { create_list(:challenge_participant, 2, challenge: meta_challenge) }
      let!(:meta_challenge_teams)                  { create_list(:team, 2, challenge: meta_challenge) }

      let!(:problem_challenge)              { create(:challenge, :running, page_views: 5, vote_count: 5) }
      let!(:chalenge_problem)               { create(:challenge_problem, challenge: meta_challenge, problem: problem_challenge) }
      let!(:problem_submissions)            { create_list(:submission, 3, challenge: problem_challenge) }
      let!(:problem_challenge_participants) { create_list(:challenge_participant, 3, challenge: problem_challenge) }
      let!(:problem_teams)                  { create_list(:team, 3, challenge: problem_challenge) }

      it 'returns statistics based on meta challenge and all it\'s problems' do
        expect(challenge_stat_count(meta_challenge, 'view')).to eq 10
        expect(challenge_stat_count(meta_challenge, 'vote')).to eq 10
        expect(challenge_stat_count(meta_challenge, 'submission')).to eq 5
        expect(challenge_stat_count(meta_challenge, 'participant')).to eq 5
        expect(challenge_stat_count(meta_challenge, 'team')).to eq 5
      end

      it 'returns statistics based on parent meta challenge and all it\'s problems' do
        expect(challenge_stat_count(problem_challenge, 'view', meta_challenge)).to eq 10
        expect(challenge_stat_count(problem_challenge, 'vote', meta_challenge)).to eq 10
        expect(challenge_stat_count(problem_challenge, 'submission', meta_challenge)).to eq 5
        expect(challenge_stat_count(problem_challenge, 'participant', meta_challenge)).to eq 5
        expect(challenge_stat_count(problem_challenge, 'team', meta_challenge)).to eq 5
      end
    end
  end
end
