require 'rails_helper'

describe ChallengesController, feature: true do
  let(:organizer) { create(:organizer) }
  let(:challenge) { create(:challenge, :running, organizers: [organizer]) }

  describe '#new' do
    context 'when user is not not logged in' do
      it 'redirects_to login page' do
        visit new_challenge_newsletter_emails_path(challenge)

        expect(page).to have_http_status 200
        expect(page).to have_current_path(new_participant_registration_path)
      end
    end

    context 'when user is logged in as participant' do
      let(:participant) { create(:participant) }

      before { login_as participant }

      it 'renders unauthorized flash' do
        visit new_challenge_newsletter_emails_path(challenge)

        expect(page).to have_http_status 200
        expect(page).to have_current_path(root_path)
        expect(page).to have_content 'You are not authorised to access this page'
      end
    end

    context 'when user is logged in as challenge organizer' do
      let(:participant) { create(:participant, organizers: [organizer]) }

      before { login_as participant }

      it 'renders new newsletter_email form' do
        visit new_challenge_newsletter_emails_path(challenge)

        expect(page).to have_http_status 200
        expect(page).to have_current_path new_challenge_newsletter_emails_path(challenge)
        expect(page).to have_content 'Send Newsletter E-mail'
      end

      it 'creates newsletter_email when form submitted with valid data' do
        visit new_challenge_newsletter_emails_path(challenge)

        fill_in 'newsletter_email_form[cc]', with: 'test@example.com'
        fill_in 'newsletter_email_form[subject]', with: 'Test Subject'
        fill_in 'newsletter_email_form[message]', with: 'Test Message'

        expect { click_on 'Send Newsletter E-mail' }.to change { NewsletterEmail.count }.by(1)

        expect(page).to have_http_status 200
        expect(page).to have_current_path new_challenge_newsletter_emails_path(challenge)
        expect(page).to have_content 'E-mail will be sent to participants after admin approval'
      end

      it 'render error flash message when form submitted with invalid data' do
        visit new_challenge_newsletter_emails_path(challenge)

        fill_in 'newsletter_email_form[cc]', with: 'INVALID_EMAIL'
        fill_in 'newsletter_email_form[subject]', with: 'Test Subject'
        fill_in 'newsletter_email_form[message]', with: 'Test Message'

        expect { click_on 'Send Newsletter E-mail' }.not_to change { NewsletterEmail.count }

        expect(page).to have_http_status 200
        expect(page).to have_current_path challenge_newsletter_emails_path(challenge)
        expect(page).to have_content 'Cc must be a list of valid e-mails that are separated by commas'
      end
    end
  end
end
