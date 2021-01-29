class CreateSubmissionNotebookJob < ApplicationJob
  queue_as :default

  def perform(submission_id, notebook_url)
    result = Notebooks::NotebookService.new(notebook_url).call
    Notebook.create!(
      notebookable_id: submission_id,
      notebookable_type: "Submission",
      s3_url: result[:notebook_s3_url],
      notebook_html: result[:notebook_html],
      gist_id: result[:gist_id]
    )
  end
end