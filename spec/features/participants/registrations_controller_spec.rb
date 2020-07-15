require 'rails_helper'

describe Participants::RegistrationsController do
  describe '#new' do
    let(:referring_participant) { create(:participant) }

    it 'renders registrations form' do
      visit new_participant_registration_path

      expect(page).to have_http_status 200
      expect(page).to have_current_path new_participant_registration_path
      expect(page).to have_content('Sign up')
    end

    it 'creates new user' do
      visit new_participant_registration_path

      fill_in 'username', with: 'new_username'
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'test12345'
      fill_in 'retypePassword', with: 'test12345'

      click_on 'Create account'

      expect(page).to have_http_status 200
      expect(page).to have_current_path root_path
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
    end
  end
end
