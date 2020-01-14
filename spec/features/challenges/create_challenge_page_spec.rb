require 'rails_helper'

describe 'create challenge page' do
  let!(:organizer)  { create(:organizer) }
  let(:participant) { create(:participant) }

  context 'not logged user' do
    before { visit new_organizer_challenge_path(organizer) }

    it 'renders login page' do
      expect_sign_in
    end
  end

  context 'logged in as participant' do
    before do
      log_in participant
      visit new_organizer_challenge_path(organizer)
    end

    it 'renders unauthorized page' do
      expect_unauthorized
    end
  end

  context 'logged in as organizer' do
    let!(:organizer_user) { create(:participant, organizer: organizer) }

    before do
      log_in organizer_user
      visit new_organizer_challenge_path(organizer)
    end

    it 'renders organizer page with Create Challenge link' do
      expect(page.status_code).to eq 200
      expect(page).to have_current_path(new_organizer_challenge_path(organizer))
      expect(page).to have_content 'Edit challenge'
    end
  end
end
