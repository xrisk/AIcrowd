require 'rails_helper'

describe 'challenge pages' do
  let!(:challenge)       { create(:challenge, :running) }
  let!(:draft_challenge) { create(:challenge, :draft) }
  let!(:participant)     { create(:participant) }

  describe 'landing page' do
    before { visit root_path }

    context 'not logged user' do
      it 'renders challenges list' do
        expect(page.status_code).to eq 200
        expect(page).to have_current_path(root_path)
        expect(page).to have_link challenge.challenge
        expect(page).to have_link 'Blog'
        expect(page).to have_link 'Challenges'
      end
    end
  end

  describe 'challenge page' do
    before { visit challenge_path(challenge) }

    context 'not logged user' do
      it 'renders challenge page' do
        expect(page.status_code).to eq 200
        expect(page).to have_current_path(challenge_path(challenge))
        expect(page).to have_content challenge.challenge
        expect(page).to have_content challenge.tagline
      end

      it "follows Overview link", js: true do
        click_link "Overview"
        expect(page).to have_content 'Overview'
      end

      it "follows Leaderboard link", js: true do
        click_link "Leaderboard"
        expect(page).to have_content 'Leaderboard'
      end

      it "cannot follow Resources link", js: true do
        click_link "Resources"
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

      it "cannot follow Resources link", js: true do
        click_link "Resources"
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'restricted pages' do
    context 'not logged user' do
      context 'cannot access restricted pages via url manipulation' do
        it "show for draft challenge" do
          visit "/challenges/#{draft_challenge.id}"
          expect(page).to have_current_path('/participants/sign_in')
        end

        it "show for running challenge" do
          visit "/challenges/#{challenge.slug}"
          expect(page).to have_current_path("/challenges/#{challenge.slug}", ignore_query: true)
        end

        it "edit challenge" do
          visit "/challenges/#{draft_challenge.id}/edit"
          expect(page).to have_content("The page you are looking for doesn’t seem to exist")
        end

        it "new challenge" do
          visit "/challenges/new"
          expect(page).to have_content("The page you are looking for doesn’t seem to exist")
        end
      end
    end
  end
end
