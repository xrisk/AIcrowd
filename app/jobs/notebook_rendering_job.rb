class NotebookRenderingJob < ApplicationJob
  queue_as :default

  def perform(submission_id)
    submission = Submission.find_by_id(submission_id)
    result = Notebooks::SubmissionNotebookService.new(submission).call
    post = Post.new(
      title: "Solution for submission #{submission_id}",
      tagline: "A detailed solution for submission #{submission_id} submitted for challenge #{submission.challenge.challenge}",
      submission_id: submission_id,
      challenge_id: submission.challenge_id,
      participant_id: submission.participant_id,
      private: true,
      notebook_s3_url: result[:notebook_s3_url],
      notebook_html: result[:notebook_html],
      gist_id: result[:gist_id],
      gist_username: ENV['GIST_USERNAME']
    )
    post.thumbnail = post.get_random_thumbnail
    post.save!
  end
end