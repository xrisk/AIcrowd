require 'rails_helper'

describe 'Challenge Teams' do
  describe 'challenge page for logged participant' do
    let!(:participation_terms) { create(:participation_terms) }
    let!(:participant)         { create(:participant) }

    before { log_in(participant) }

    context 'challenge with not allowed teams' do
      let!(:challenge_no_teams)    { create(:challenge, :running, teams_allowed: false) }
      let!(:challenge_rules)       { create(:challenge_rules, challenge: challenge_no_teams) }
      let!(:challenge_participant) { create(:challenge_participant, challenge: challenge_no_teams, participant: participant) }

      it 'does not render team links' do
        visit challenge_path(challenge_no_teams)

        expect(page).not_to have_content 'My Team'
        expect(page).not_to have_content 'Create Team'
      end
    end

    context 'challenge with allowed teams' do
      let!(:challenge_with_max_5_members) { create(:challenge, :running, teams_allowed: true) }
      let!(:challenge_rules)              { create(:challenge_rules, challenge: challenge_with_max_5_members) }
      let!(:challenge_participant)        { create(:challenge_participant, challenge: challenge_with_max_5_members, participant: participant) }

      it 'renders team links' do
        visit challenge_path(challenge_with_max_5_members)

        expect(page).to have_content 'Create Team'
      end
    end
  end
end
