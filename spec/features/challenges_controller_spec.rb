require 'rails_helper'

describe ChallengesController, feature: true do
  describe '#show' do
    context 'when user is logged in as participant' do
      let(:participant) { create(:participant) }

      before { log_in participant }

      context 'when challenge does not have teams allowed' do
        let!(:challenge) { create(:challenge, :running, teams_allowed: false) }

        it 'renders only Participate button' do
          visit challenge_path(challenge)

          expect(page).to have_http_status 200
          expect(page).to have_current_path challenge_path(challenge)
          expect(page).to have_content 'Participate'
          expect(page).not_to have_content 'Create Team'
          expect(page).not_to have_content 'My Team'
        end
      end

      context 'when challenge has teams allowed' do
        let!(:challenge)             { create(:challenge, :with_rules, :running, teams_allowed: true) }
        let!(:challenge_participant) { create(:challenge_participant, challenge: challenge, participant: participant) }

        context 'when participant is not a part of team' do
          it 'renders only Create Team button' do
            visit challenge_path(challenge)

            expect(page).to have_http_status 200
            expect(page).to have_current_path challenge_path(challenge)
            expect(page).not_to have_content 'Participate'
            expect(page).to have_content 'Create Team'
            expect(page).not_to have_content 'My Team'
          end
        end

        context 'when participant is part of a team' do
          let!(:team)             { create(:team, challenge: challenge) }
          let!(:team_participant) { create(:team_participant, team: team, participant: participant) }

          it 'renders only My Team button' do
            visit challenge_path(challenge)

            expect(page).to have_http_status 200
            expect(page).to have_current_path challenge_path(challenge)
            expect(page).not_to have_content 'Participate'
            expect(page).not_to have_content 'Create Team'
            expect(page).to have_content 'My Team'
          end
        end
      end
    end
  end
end
