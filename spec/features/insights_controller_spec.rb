require 'rails_helper'

describe InsightsController, feature: true do
  describe '#index' do
    let!(:challenge) { create(:challenge, :completed) }
    let!(:challenge_round_active) { challenge.active_round }
    let!(:challenge_round_non_active) { create(:challenge_round, challenge: challenge, challenge_round: 'non active') }

    context 'when user is not logged in' do
      it 'renders active round charts' do
        visit challenge_insights_path(challenge)

        expect(page).to have_http_status :ok
        expect(page).to have_current_path challenge_insights_path(challenge)
        expect(page).to have_content('Submissions vs Time')
        expect(page).to have_content('Best Score vs Time')
        expect(page).to have_content('Geo Chart')
        expect(page).to have_content(challenge_round_active.challenge_round)
      end

      it 'renders non active round charts' do
        visit challenge_insights_path(challenge, challenge_round_id: challenge_round_non_active.id)

        expect(page).to have_http_status :ok
        expect(page).to have_current_path challenge_insights_path(challenge, challenge_round_id: challenge_round_non_active.id)
        expect(page).to have_content('Submissions vs Time')
        expect(page).to have_content('Best Score vs Time')
        expect(page).to have_content('Geo Chart')
        expect(page).to have_content(challenge_round_non_active.challenge_round)
      end
    end
  end
end
