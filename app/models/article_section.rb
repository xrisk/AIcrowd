class ArticleSection < ApplicationRecord
  include FriendlyId
  include Markdownable

  default_scope { order('seq ASC') }

  belongs_to :article
  validates :section, presence: true
  validates :section,
            uniqueness: { allow_blank: false,
                          scope:       :article }

  friendly_id :section, use: [:slugged, :finders, :history]

  def should_generate_new_friendly_id?
    section_changed?
  end
end
