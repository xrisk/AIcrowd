class DatasetFile < ApplicationRecord
  belongs_to :challenge
  has_many :dataset_file_downloads, dependent: :destroy

  attr_accessor :error_message

  validates :description, presence: true
end
