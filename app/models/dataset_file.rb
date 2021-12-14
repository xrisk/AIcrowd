class DatasetFile < ApplicationRecord
  belongs_to :challenge
  attr_accessor :error_message

  validates :description, presence: true
end
