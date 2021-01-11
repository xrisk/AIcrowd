class LockedSubmission < ApplicationRecord
  default_scope { where(deleted: false) }
end
