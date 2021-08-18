class Publication < ApplicationRecord
  has_paper_trail
  include FriendlyId
  friendly_id :title, use: :slugged

  has_many :authors, foreign_key: :publication_id, class_name: "PublicationAuthor", dependent: :destroy
  has_many :external_links, foreign_key: :publication_id, class_name: "PublicationExternalLink", dependent: :destroy
  has_and_belongs_to_many :venues, class_name: "PublicationVenue"
  has_many :category_publications, dependent: :destroy
  has_many :categories, through: :category_publications

  belongs_to :challenge, optional: true

  default_scope { order(:sequence) }

  mount_uploader :thumbnail, RawImageUploader

  accepts_nested_attributes_for :authors, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :venues, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :external_links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :categories
end
