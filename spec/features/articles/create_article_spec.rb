require 'rails_helper'

describe "create knowledge base article" do
  let(:participant) { create :participant }
  let(:admin) { create :participant, :admin }

  it 'not logged in' do
    visit new_article_path
    expect(page).not_to have_text 'New Tutorial'
  end

  it 'participant' do
    log_in(participant)
    visit new_article_path
    expect(page).to have_text 'New Tutorial'
    expect(page).to have_field(
      'article_published',
      type:     'checkbox',
      disabled: true)
  end

  it 'admin' do
    log_in(admin)
    visit new_article_path
    expect(page).to have_text 'New Tutorial'
    expect(page).to have_field(
      'article_published',
      type:     'checkbox',
      disabled: false)
  end
end
