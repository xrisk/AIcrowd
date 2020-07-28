require 'rails_helper'

describe ChallengesHelper do
  describe 'challenge_stat_count(challenge, stat_type, parent_meta_challenge)' do
    context 'when standard challenge passed in parameters' do
      let!(:challenge)              { create(:challenge, :running, page_views: 10) }
      let!(:submissions)            { create_list(:submission, 2, challenge: challenge) }
      let!(:challenge_participants) { create_list(:challenge_participant, 2, challenge: challenge) }
      let!(:teams)                  { create_list(:team, 2, challenge: challenge) }

      it 'returns statistics based on standard challenge' do
        expect(challenge_stat_count(challenge, 'view')).to eq 10
        expect(challenge_stat_count(challenge, 'submission')).to eq 2
        expect(challenge_stat_count(challenge, 'participant')).to eq 2
        expect(challenge_stat_count(challenge, 'team')).to eq 2
      end
    end

    context 'when meta challenge or problem passed in parameters' do
      let!(:meta_challenge)                        { create(:challenge, :running, :meta_challenge, page_views: 10) }
      let!(:second_problem_challenge_participants) { create_list(:challenge_participant, 5, challenge: meta_challenge) }
      let!(:second_problem_teams)                  { create_list(:team, 5, challenge: meta_challenge) }

      let!(:first_problem_challenge)               { create(:challenge, :running, page_views: 5) }
      let!(:first_chalenge_problem)                { create(:challenge_problem, challenge: meta_challenge, problem: first_problem_challenge) }
      let!(:first_problem_submissions)             { create_list(:submission, 3, challenge: first_problem_challenge, meta_challenge: meta_challenge) }

      let!(:second_problem_challenge)              { create(:challenge, :running, page_views: 5) }
      let!(:second_chalenge_problem)               { create(:challenge_problem, challenge: meta_challenge, problem: second_problem_challenge) }
      let!(:second_problem_submissions)            { create_list(:submission, 2, challenge: second_problem_challenge, meta_challenge: meta_challenge) }

      it 'returns statistics based on meta challenge and it\'s problems' do
        expect(challenge_stat_count(meta_challenge, 'view')).to eq 10
        expect(challenge_stat_count(meta_challenge, 'submission')).to eq 5
        expect(challenge_stat_count(meta_challenge, 'participant')).to eq 5
        expect(challenge_stat_count(meta_challenge, 'team')).to eq 5
      end

      it 'returns statistics based on parent meta challenge and it\'s problems' do
        expect(challenge_stat_count(first_problem_challenge, 'view', meta_challenge)).to eq 5
        expect(challenge_stat_count(first_problem_challenge, 'submission', meta_challenge)).to eq 3
        expect(challenge_stat_count(first_problem_challenge, 'participant', meta_challenge)).to eq 5
        expect(challenge_stat_count(first_problem_challenge, 'team', meta_challenge)).to eq 5
      end
    end
  end
end
