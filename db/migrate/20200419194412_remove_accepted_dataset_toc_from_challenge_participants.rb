class RemoveAcceptedDatasetTocFromChallengeParticipants < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenge_participants, :accepted_dataset_toc, :boolean
  end
end
