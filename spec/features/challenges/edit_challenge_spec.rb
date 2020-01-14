require 'rails_helper'

feature 'An organizer edits a challenge' do
  let!(:challenge) { create(:challenge, organizer: organizer) }

  context 'logged in as organizer' do
    let(:organizer)      { create(:organizer) }
    let(:organizer_user) { create(:participant, organizer: organizer) }

    before do
      log_in organizer_user
      visit edit_organizer_challenge_path(challenge.organizer_id, challenge.slug)
    end

    scenario 'update challenge', js: true do
      expect(page).to have_current_path(edit_organizer_challenge_path(challenge.organizer_id, challenge.slug))

      fill_in 'challenge_challenge', with: 'something new'

      click_button 'Update challenge'

      expect(page).to have_current_path(organizer_challenge_path(organizer.slug, challenge.reload.slug))
      expect(page).to have_content 'Challenge updated.'
      expect(page).to have_content 'something new'
    end
  end
end
