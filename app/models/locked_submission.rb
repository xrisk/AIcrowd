class LockedSubmission < ApplicationRecord

  belongs_to :challenge
  default_scope { where(deleted: false) }
end
