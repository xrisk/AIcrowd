class TerminateChallenges
  def call
    running_challenges = Challenge.where(status_cd: :running)
    running_challenges.each do |c|
      c.update(status: :completed) if c.end_dttm.present? && c.end_dttm <= Time.current
    end
  end
end
