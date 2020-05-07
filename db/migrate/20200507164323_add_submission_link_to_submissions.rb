class AddSubmissionLinkToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :submission_link, :string
  end
end
