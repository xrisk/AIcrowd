require 'rails_helper'

describe 'ActiveAdmin NewsletterEmail', feature: true do
  let(:admin) { create(:participant, :admin) }

  describe '#index' do
    let!(:newsletter_emails) { create_list(:newsletter_email, 3, subject: 'NewsletterEmail Subject') }

    context 'when user is not logged in' do
      it 'renders 404 page' do
        visit admin_newsletter_emails_path

        expect(page).to have_http_status(404)
      end
    end

    context 'when user is logged in as admin' do
      before { login_as(admin) }

      it 'renders index page' do
        visit admin_newsletter_emails_path

        expect(page).to have_http_status 200
        expect(page).to have_current_path admin_newsletter_emails_path
        expect(page).to have_content 'NewsletterEmail Subject'
      end
    end
  end

  describe '#show' do
    let(:newsletter_email) { create(:newsletter_email, subject: 'NewsletterEmail Subject') }

    context 'when user is not logged in' do
      it 'renders 404 page' do
        visit admin_newsletter_email_path(newsletter_email)

        expect(page).to have_http_status(404)
      end
    end

    context 'when user is logged in as admin' do
      before { login_as(admin) }

      it 'renders show page' do
        visit admin_newsletter_email_path(newsletter_email)

        expect(page).to have_http_status 200
        expect(page).to have_current_path admin_newsletter_email_path(newsletter_email)
        expect(page).to have_content 'NewsletterEmail Subject'
      end

      it 'allows to approve newsletter_email' do
        visit admin_newsletter_email_path(newsletter_email)

        expect { click_on 'Approve' }.to have_enqueued_job(Organizers::NewsletterEmailJob)

        expect(page).to have_http_status 200
        expect(page).to have_current_path admin_newsletter_emails_path
        expect(page).to have_content 'Newsletter email has been sent to participants.'
      end

      it 'allows to decline newsletter_email' do
        visit admin_newsletter_email_path(newsletter_email)

        click_on 'Decline'

        expect(page).to have_http_status 200
        expect(page).to have_current_path admin_newsletter_emails_path
        expect(page).to have_content 'Newsletter email has been declined.'
      end
    end
  end
end
