class Publication < ApplicationRecord
  has_paper_trail
  include FriendlyId
  friendly_id :title, use: :slugged

  has_many :publication_authors
  has_many :publication_external_links
  has_many :publication_venues

  belongs_to :challenge, optional: true

  mount_uploader :thumbnail, RawImageUploader

  accepts_nested_attributes_for :publication_authors, reject_if: :all_blank
  accepts_nested_attributes_for :publication_venues, reject_if: :all_blank
  accepts_nested_attributes_for :publication_external_links, reject_if: :all_blank
end
