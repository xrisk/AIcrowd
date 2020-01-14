require 'rails_helper'

describe "Editing and deletion of topics" do
  let!(:participant) { create :participant }
  let!(:author) { create :participant }
  let!(:admin) { create :participant, :admin }
  let!(:topic) { create :topic, participant: author }

  it 'public user' do
    visit "/topics/#{topic.slug}/comments/new"
    expect(page).to have_content topic.topic
    # expect(page).not_to have_link 'Edit'
    # expect(page).not_to have_link 'Delete'
  end

  it 'participant' do
    log_in(participant)
    visit "/topics/#{topic.slug}/comments/new"
    expect(page).to have_content topic.topic
    # expect(page).not_to have_link 'Edit'
    # expect(page).not_to have_link 'Delete'
  end

  it 'author' do
    log_in(author)
    visit "/topics/#{topic.slug}/comments/new"
    expect(page).to have_content topic.topic
    # expect(page).not_to have_link 'Edit'
    # expect(page).not_to have_link 'Delete'
  end

  it 'admin' do
    log_in(admin)
    visit "/topics/#{topic.slug}/comments/new"
    expect(page).to have_content topic.topic
    # expect(page).to have_link 'Edit'
    # expect(page).to have_link 'Delete'
  end
end
