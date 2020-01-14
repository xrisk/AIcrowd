require 'rails_helper'

describe 'download dataset links' do
  let!(:challenge)                       { create(:challenge, :running) }
  let!(:challenge_rules)                 { create(:challenge_rules, challenge: challenge) }
  let!(:participation_terms)             { create(:participation_terms) }

  context 'logged in as participant' do
    let!(:participant)           { create(:participant) }
    let!(:challenge_participant) { create(:challenge_participant, challenge: challenge, participant: participant) }

    before do
      log_in(participant)
      visit challenge_dataset_files_path(challenge)
    end

    it 'renders only Download links' do
      expect(page.status_code).to eq 200
      expect(page).to have_current_path(challenge_dataset_files_path(challenge))
      expect(page).not_to have_link 'Delete'
      expect(page).to have_link 'first_file'
      expect(page).to have_link 'Download'
    end
  end

  context 'logged in as organizer' do
    let!(:organizer)                       { create(:participant, organizer: challenge.organizer) }
    let!(:challenge_organizer_participant) { create(:challenge_participant, challenge: challenge, participant: organizer)   }

    before do
      log_in(organizer)
      visit challenge_dataset_files_path(challenge)
    end

    it 'renders both Delete and Download links' do
      expect(page.status_code).to eq 200
      expect(page).to have_current_path(challenge_dataset_files_path(challenge))
      expect(page).to have_link 'Delete'
      expect(page).to have_link 'first_file'
      expect(page).to have_link 'Download'
    end
  end

  context 'logged in as admin' do
    let!(:admin)                       { create(:participant, :admin) }
    let!(:challenge_admin_participant) { create(:challenge_participant, challenge: challenge, participant: admin) }

    before do
      log_in(admin)
      visit challenge_dataset_files_path(challenge)
    end

    it 'renders both Delete and Download links' do
      expect(page.status_code).to eq 200
      expect(page).to have_current_path(challenge_dataset_files_path(challenge))
      expect(page).to have_link 'Delete'
      expect(page).to have_link 'first_file'
      expect(page).to have_link 'Download'
    end
  end
end
