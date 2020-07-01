class MlChallenge::AwardPointJob < ApplicationJob
  queue_as :default

  def perform(obj_record, key)
    MlChallenge::AwardPointService.new(obj_record, key).call
  end
end
