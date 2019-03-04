require 'rails_helper'

feature "unauthorized" do
  let!(:organizer) { create :organizer }
  let(:participant) { create :participant }

  scenario 'not logged in' do
    visit new_organizer_challenge_path(organizer)
    expect_sign_in
  end

  scenario 'user logged in' do
    log_in participant
    visit new_organizer_challenge_path(organizer)
    expect_unauthorized
  end
end


feature 'An organizer creates a challenge' do
  let!(:organizer) { create :organizer }
  let!(:participant) { create :participant, organizer: organizer }
  let!(:challenge) { build :challenge }

  scenario 'create challenge', js: true do
    log_in participant
    visit organizer_path(organizer, wait: 1)
    expect(page).to have_text organizer.organizer
    # expect(page).to have_selector '.btn', text: 'CREATE CHALLENGE'
  end

end
