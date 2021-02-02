class SubmissionFile < ApplicationRecord
  belongs_to :submission

  default_scope { order('seq ASC') }

  after_commit :create_notebook, on: :create

  def create_notebook
    if self.submission_type == "ipynb"
      CreateSubmissionNotebookJob.perform_later(self.submission_id, self.submission_file_s3_key)
    end
  end

end
