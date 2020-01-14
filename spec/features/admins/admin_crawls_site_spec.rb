require 'rails_helper'

describe 'site navigation for admin' do
  let!(:participant) { create(:participant, :admin) }
  let!(:challenges)  { create_list(:challenge, 3, :running) }
  let!(:articles)    { create_list(:article, 3, :with_sections) }
  let!(:draft)       { create(:challenge, :draft) }

  let(:challenge) { challenges.first }
  let(:article)   { articles.first }
  let(:organizer) { challenge.organizer }

  before { log_in(participant) }

  context 'landing page' do
    before { visit root_path }

    it 'renders landing page' do
      expect(page.status_code).to eq 200
      expect(page).to have_current_path(root_path)
    end

    it 'renders menu links' do
      expect(page).to have_link 'Challenges'
      expect(page).to have_link 'Blog'
      expect(page).to have_link 'Admin'
    end

    it 'renders challenges tiles' do
      expect(page).to have_content challenges.first.challenge
      expect(page).to have_content challenges.second.challenge
      expect(page).to have_content challenges.third.challenge
      expect(page).not_to have_content draft.challenge
    end
  end

  context 'challenge page' do
    before { visit challenge_path(challenge) }

    it 'renders challenge page' do
      expect(page.status_code).to eq 200
      expect(page).to have_current_path(challenge_path(challenge))
    end

    it 'renders challenge page links' do
      expect(page).to have_link 'Overview'
      expect(page).to have_link 'Leaderboard'
      expect(page).to have_link 'Discussion'
      expect(page).to have_link 'Resources'
      expect(page).to have_link 'Submissions'
      expect(page).to have_link 'Participants'
      expect(page).to have_link 'Follow'
      expect(page).to have_link 'Participate'
      expect(page).to have_link 'Edit Challenge'
    end

    it 'allows to switch tabs', js: true do
      click_link 'Overview'
      expect(page).to have_link 'Overview', class: 'active'

      click_link 'Leaderboard'
      expect(page).to have_link 'Leaderboard', class: 'active'

      click_link 'Submissions'
      expect(page).to have_link 'Submissions', class: 'active'

      click_link 'Participants'
      expect(page).to have_link 'Participants', class: 'active'
    end

    it 'renders link to organizer page' do
      click_link organizer.organizer

      expect(page.status_code).to eq 200
      expect(page).to have_current_path(organizer_path(organizer))
      expect(page).to have_link 'Challenges', class: 'active'
      expect(page).to have_link 'Members'
    end
  end
end
