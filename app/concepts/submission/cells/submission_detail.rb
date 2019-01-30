class Submission::Cell::SubmissionDetail < Submission::Cell

  def show
    render :submission_detail
  end

  def entry
  	model
  end

end
