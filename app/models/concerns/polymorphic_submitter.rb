module PolymorphicSubmitter
  extend ActiveSupport::Concern

  included do
    belongs_to :submitter, polymorphic: true, optional: true
    has_one :self_ref, class_name: "::#{name}", foreign_key: :id
    has_one :participant, through: :self_ref, source: :submitter, source_type: 'Participant'
    has_one :team, through: :self_ref, source: :submitter, source_type: 'Team'
  end

  def show_leaderboard?
    return false if starting_soon_mode?
    return false unless challenge.challenge_rounds.present?

    leaderboard_public?
  end

  def starting_soon_mode?
    challenge.status == :starting_soon
  end

  def leaderboard_public?
    challenge.show_leaderboard == true
  end
end
