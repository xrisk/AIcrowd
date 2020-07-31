class AicrowdUserBadge < ApplicationRecord
  belongs_to :aicrowd_badge
  belongs_to :participant
  scope :with_badge_meta, -> { joins('left outer join aicrowd_badges ab on ab.id=aicrowd_badge_id') }
  scope :with_badge_meta, -> { joins('left outer join aicrowd_badges ab on ab.id=aicrowd_badge_id') }
  scope :filter_by_badge_type, ->(badge_type) { where("ab.badge_type_id=#{badge_type&.id.to_i}") }
  scope :select_display_fields, -> { select('ab.name, ab.created_at') }
  scope :individual_badges, ->(badge_type) { with_badge_meta.filter_by_badge_type(badge_type) }
  scope :badges_stat_count, -> { with_badge_meta.joins('left outer join badge_types bt on bt.id=ab.badge_type_id').group('ab.badge_type_id').count }
end
