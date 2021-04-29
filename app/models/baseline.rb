class Baseline < ApplicationRecord
  belongs_to :challenge
  before_save :check_default_baseline, on: [:create, :update]

  def check_default_baseline
    if self.default && self.challenge.baselines.where(default: true).exists?
      self.challenge.baselines.where(default: true).update_all(default: false)
    end

    if self.challenge.baselines.where(default: true).blank?
      self.default = true
    end
  end

end
