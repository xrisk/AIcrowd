require 'rails_helper'

describe "download dataset links" do
  let!(:challenge) { create :challenge, :running }
  let!(:challenge_rules) do
    create :challenge_rules,
           challenge: challenge
  end
  let!(:participation_terms) do
    create :participation_terms
  end
  let!(:participant) { create :participant }
  let!(:challenge_participant) do
    create :challenge_participant,
           challenge:   challenge,
           participant: participant
  end
  let!(:admin) { create :participant, :admin }
  let!(:challenge_admin_participant) do
    create :challenge_participant,
           challenge:   challenge,
           participant: admin
  end
  let!(:organizer) { create :participant, organizer: challenge.organizer }
  let!(:challenge_organizer_participant) do
    create :challenge_participant,
           challenge:   challenge,
           participant: organizer
  end

  context 'download link' do
    it 'participant' do
      log_in(participant)
      visit challenge_dataset_files_path(challenge, wait: 1)
      expect(page).not_to have_link 'Delete'
    end

    it 'admin' do
      log_in(admin)
      visit challenge_dataset_files_path(challenge, wait: 1)
      expect(page).to have_link 'Delete'
    end

    it 'organizer' do
      log_in(organizer)
      visit challenge_dataset_files_path(challenge, wait: 1)
      expect(page).to have_link 'Delete'
    end
    # TODO after participant terms is fixed
    # scenario 'download file', js: true do
    #   log_in(admin)
    #   visit challenge_dataset_files_path(challenge, wait: 1)
    #   click_link 'first_file'
    #   expect(DatasetFileDownload.count).to eq(1)
    # end
  end
end
