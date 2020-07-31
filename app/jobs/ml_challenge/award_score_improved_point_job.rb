class MlChallenge::AwardScoreImprovedPointJob < ApplicationJob
  queue_as :default

  def perform(obj_id, obj_type, key)
    obj_record = obj_type.constantize.find(obj_id) # Submission Object

    MlChallenge::AwardScoreImprovedPointService.new(obj_record, key).call
  end
end
