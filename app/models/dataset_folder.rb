class DatasetFolder < ApplicationRecord
  belongs_to :challenge

  attr_accessor :dataset_files, :error_message

  validates :title, presence: true
  validates :directory_path, presence: true
  validates :aws_access_key, presence: true
  validates :aws_secret_key, presence: true
  validates :bucket_name, presence: true
end
