class UpdateChallengeStatsJob < ApplicationJob
  queue_as :default

  def perform
    update_submissions
  end

  def update_submissions
    sql = %Q[
      UPDATE challenges AS C
      SET submission_count =
          (SELECT COUNT(*)
             FROM submissions s
            WHERE s.challenge_id = c.id)
      ]
    result = ActiveRecord::Base.connection.execute(sql)
    logger.info("challenge submissions updated rowcount: #{result.cmd_tuples()}")
  end

end
