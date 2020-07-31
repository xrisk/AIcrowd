class MlActivityPoint < ApplicationRecord
  belongs_to :participant, class_name: 'Participant'
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :activity_point, class_name: 'ActivityPoint'

  def self.sum_points
    # call as participant.ml_activity_points.sum_points

    get_scores

    @activity_score + @improved_activity_score
  end

  def self.sum_points_by_day
    # call as participant.ml_activity_points.group_by_day(:created_at, format: "%Y-%m-%d").sum_points_by_day

    get_scores

    @activity_score.merge(@improved_activity_score)
  end

  def self.get_scores
    # activity_key: "score_improved_over_5_times" has own point, based on times of improvement
    @activity_score = joins(:activity_point).where.not('activity_points.activity_key = ?', 'score_improved_over_5_times').sum('activity_points.point')

    @improved_activity_score = joins(:activity_point).where('activity_points.activity_key = ?', 'score_improved_over_5_times').sum('point')
  end
end
