class AddSubmissionNoteToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :submission_note, :text
  end
end
