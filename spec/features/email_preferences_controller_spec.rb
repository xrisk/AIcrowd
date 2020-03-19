require 'rails_helper'

describe ClefTasksController, feature: true do
  describe '#edit' do
    let(:participant) { create(:participant, agreed_to_organizers_newsletter: true) }

    context 'when user is not logged in' do
      it 'redirects to login page and displays unauthorized flash' do
        visit participant_notifications_path(participant)

        expect(page).to have_http_status(200)
        expect(page).to have_current_path new_participant_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when user is logged in' do
      before { log_in participant }

      it 'renders edit form' do
        visit participant_notifications_path(participant)

        expect(page).to have_http_status(200)
        expect(page).to have_current_path participant_notifications_path(participant)
        expect(page).to have_content 'Account Settings'
      end

      it 'allows to update participant settings' do
        visit participant_notifications_path(participant)

        uncheck 'participant_agreed_to_organizers_newsletter'

        click_on 'Update'

        expect(page).to have_http_status(200)
        expect(page).to have_current_path participant_notifications_path(participant)
        expect(page).to have_content 'Your email preferences were successfully updated.'
        expect(participant.reload.agreed_to_organizers_newsletter).to eq false
      end
    end
  end
end
