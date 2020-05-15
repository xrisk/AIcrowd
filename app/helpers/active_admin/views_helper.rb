module ActiveAdmin::ViewsHelper
  def edit_challenge_link(challenge)
    challenge.is_a_problem? ? edit_challenge_problem_path(challenge.challenge_problem.challenge, challenge) : edit_challenge_path(challenge)
  end
end
