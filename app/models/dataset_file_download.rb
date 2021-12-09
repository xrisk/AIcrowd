class DatasetFileDownload < ApplicationRecord
  validates :ip_address,
            presence:   true,
            uniqueness: false
  validates :participant_id,      presence: true
end
