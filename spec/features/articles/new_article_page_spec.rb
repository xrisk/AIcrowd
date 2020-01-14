require 'rails_helper'

describe 'new article page' do
  let(:participant) { create(:participant) }
  let(:admin)       { create(:participant, :admin) }

  describe 'new article page' do
    context 'not logged user' do
      it 'redirects to login page' do
        visit new_article_path

        expect(page.status_code).to eq 200
        expect(page).to have_current_path(new_participant_session_path)
      end
    end

    context 'participant' do
      it 'renders new article form with disabled article_published checkbox' do
        log_in(participant)
        visit new_article_path

        expect(page.status_code).to eq 200
        expect(page).to have_current_path(new_article_path)
        expect(page).to have_text 'New Tutorial'
        expect(page).to have_field 'article_published', type: 'checkbox', disabled: true
      end
    end

    context 'admin' do
      it 'renders new article form with enabled article_published checkbox' do
        log_in(admin)
        visit new_article_path

        expect(page.status_code).to eq 200
        expect(page).to have_current_path(new_article_path)
        expect(page).to have_text 'New Tutorial'
        expect(page).to have_field 'article_published', type: 'checkbox', disabled: false
      end
    end
  end
end
