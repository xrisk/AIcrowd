class MlActivityPoint < ApplicationRecord
  belongs_to :participant, class_name: 'Participant'
  belongs_to :challenge, class_name: 'Challenge'
  belongs_to :activity_point, class_name: 'ActivityPoint'

  def self.sum_points
    # activity_key: "score_improved_over_5_times" has own point, based on times of improvement
    activity_score = joins(:activity_point).where.not("activity_points.activity_key = ?", 'score_improved_over_5_times').sum('activity_points.point')

    improved_activity_score = joins(:activity_point).where("activity_points.activity_key = ?", 'score_improved_over_5_times').sum('point')

    activity_score + improved_activity_score
  end
end
