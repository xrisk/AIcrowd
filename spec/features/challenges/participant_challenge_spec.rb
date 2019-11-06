require 'rails_helper'

feature "participant accesses challenge", js: true do
let!(:challenge) { create(:challenge, :running) }
let!(:challenge_rules) { create :challenge_rules, challenge: challenge }
let!(:draft_challenge) { create(:challenge, :draft) }
let!(:participant) { create(:participant) }

  describe "participant can view challenges list" do
    before(:example) do
      log_in participant
      visit '/challenges'
    end
    specify { expect(page).to have_link challenge.challenge }
    # specify { expect(page).to have_link 'Knowledge Base' }
    specify { expect(page).to have_link 'Challenges' }
  end


  describe "participant can view challenge details" do
    before(:example) do
      log_in participant
      visit '/challenges'
      click_link challenge.challenge
    end

    specify { expect(page).to have_content challenge.challenge }
    specify { expect(page).to have_content challenge.tagline }
  end

  describe "participant" do
    before do
      log_in participant
      visit '/challenges'
      click_link challenge.challenge
    end

    scenario "can follow Overview link" do
      click_link "Overview"
      expect(page).to have_content 'Overview'
    end

    scenario "can follow Leaderboard link" do
      click_link "Leaderboard"
      expect(page).to have_content 'Leaderboard'
    end

    scenario "can follow Resources link" do
      click_link "Resources"
      expect(page).to have_content 'Resources'
    end
  end

  describe "access restricted parts of the challenge" do
    before(:example) do
      log_in participant
      visit '/challenges'
      click_link challenge.challenge
    end

    scenario "follow Leaderboard link" do
      click_link "Leaderboard"
      expect(page).to have_content 'Leaderboard'
    end

    scenario "follow Resources link" do
      click_link "Resources"
      expect(page).to have_content 'Resources'
    end

  end
end
