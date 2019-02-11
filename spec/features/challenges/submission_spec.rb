require "rails_helper"

feature 'submissions not allowed' do
  let!(:participation_terms) {
    create :participation_terms
  }
  let!(:running) { create :challenge, :running, online_submissions: true }
  let!(:draft) { create :challenge }
  let!(:draft_rules) {
    create :challenge_rules,
    challenge: draft
  }
  let!(:starting_soon) {
    create :challenge, :starting_soon }
  let!(:starting_soon_challenge_rules) {
    create :challenge_rules,
    challenge: starting_soon
  }
  let!(:completed_closed) {
    create :challenge,
      :completed,
      online_submissions: true,
      post_challenge_submissions: false }
  let!(:completed_closed_challenge_rules) {
    create :challenge_rules,
    challenge: completed_closed
  }
  let(:participant) { create :participant }
  let!(:starting_soon_participant) {
    create :challenge_participant,
    challenge: starting_soon,
    participant: participant
  }
  let!(:completed_closed_participant) {
    create :challenge_participant,
    challenge: completed_closed,
    participant: participant
  }
  let!(:draft_participant) {
    create :challenge_participant,
    challenge: draft,
    participant: participant
  }

  scenario 'public user' do
    visit new_challenge_submission_path(running)
    expect_sign_in
    visit new_challenge_submission_path(draft)
    expect_sign_in
    visit new_challenge_submission_path(starting_soon)
    expect_sign_in
    visit new_challenge_submission_path(completed_closed)
    expect_sign_in
  end

  scenario 'participant' do
    log_in participant
    visit new_challenge_submission_path(draft)
    expect_unauthorized
    visit new_challenge_submission_path(starting_soon)
    expect_unauthorized
    visit new_challenge_submission_path(completed_closed)
    expect_unauthorized
  end
end

feature 'challenge running' do
  let!(:participation_terms) {
    create :participation_terms
  }
  let!(:running) { create :challenge, :running, online_submissions: true }
  let!(:running_rules) {
    create :challenge_rules,
    challenge: running
  }
  let(:participant) { create :participant }
  let!(:running_participant) {
    create :challenge_participant,
    challenge: running,
    participant: participant
  }
  scenario do
    log_in participant
    visit new_challenge_submission_path(running)
    expect(page).to have_text 'Create Submission'
  end
end

feature 'challenge ended' do
  let!(:participation_terms) {
    create :participation_terms
  }
  let!(:challenge) {
    create :challenge,
      :completed,
      online_submissions: true,
      post_challenge_submissions: true }
  let!(:challenge_rules) {
    create :challenge_rules,
    challenge: challenge
  }
  let(:participant) { create :participant }
  let!(:challenge_participant) {
    create :challenge_participant,
    challenge: challenge,
    participant: participant
  }
  scenario do
    log_in participant
    visit new_challenge_submission_path(challenge)
    expect(page).to have_text 'Create Submission'
    expect(page).to have_text 'This challenge is now completed. You may continue to make submissions and your entries will appear on the Ongoing Leaderboard.'
  end

  scenario do
    challenge.update(post_challenge_submissions: false)
    log_in participant
    visit new_challenge_submission_path(challenge)
    expect_unauthorized
  end
end
