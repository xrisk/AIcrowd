require 'rails_helper'

describe 'public user accesses challenge', :js do
  let!(:organizer)   { create :organizer }
  let!(:participant) { create :participant, organizers: [organizer] }
  let!(:challenge)   { create :challenge, organizers: [organizer] }
  let!(:invitation)  { create(:invitation, challenge_id: challenge.id, participant_id: participant.id, email: 'invited@user.com') }

  describe 'Logged in user should invite participant' do
    before do
      log_in(participant)
      visit "/challenges/#{challenge.id}/edit?step=private-challenge"
    end

    it 'Invite participant by email' do
      click_button '+ Invite participant'
      fill_in 'challenge[invitation_email]', with: 'participant1@user.com, participant2@user.com'

      click_button 'Update challenge'
      expect(page).to have_text 'Challenge updated.'

      visit "/challenges/#{challenge.id}/edit?step=private-challenge"
      expect(page).to have_text 'participant1@user.com'
    end
  end

  context 'Logged in user should remove invited participant' do
    before do
      log_in(participant)
      visit "/challenges/#{challenge.id}/edit?step=private-challenge"
    end
    it 'Remove invited participant to remove link' do
      click_link 'remove'

      expect(page).to have_no_content 'invited@user.com'
      expect(page).to have_current_path edit_challenge_path(challenge.id, step: 'private-challenge')
    end
  end
end
