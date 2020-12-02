class AddSubmissionReceivedFromToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :submission_received_from, :string, default: "web"
  end
end
