require 'rails_helper'

describe "public user accesses challenge", :js do
  let!(:organizer)   { create :organizer }
  let!(:participant) { create :participant, organizer: organizer }
  let!(:challenge)   { create :challenge, organizer: organizer }

  describe "Logged in user should invite participant" do
    before do
      log_in(participant)
      visit "/challenges/#{challenge.id}/edit?step=private-challenge"
    end

    it "Invite participant by email" do
      click_button '+ Invite participant'
      fill_in 'challenge[invitation_email]', with: 'participant1@user.com, participant2@user.com'

      click_button 'Update challenge'
      expect(page).to have_text "Challenge updated."

      visit "/challenges/#{challenge.id}/edit?step=private-challenge"
      expect(page).to have_text "participant1@user.com"
    end
  end
end
