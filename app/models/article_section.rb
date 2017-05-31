# == Schema Information
#
# Table name: article_sections
#
#  id                   :integer          not null, primary key
#  article_id           :integer
#  seq                  :integer          default(1)
#  description_markdown :text
#  description          :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  section              :string
#  slug                 :string
#
# Indexes
#
#  index_article_sections_on_article_id  (article_id)
#  index_article_sections_on_slug        (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_2f1fa44b2d  (article_id => articles.id)
#

class ArticleSection < ApplicationRecord
  include FriendlyId

  default_scope { order('seq ASC') }

  belongs_to :article

  validates_presence_of :section
  validates_uniqueness_of :section, allow_blank: false, scope: :article

  before_validation :cache_rendered_markdown

  friendly_id :section, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    section_changed?
  end

  private
  def cache_rendered_markdown
    if description_markdown_changed?
      self.description = RenderMarkdown.new.render(description_markdown)
    end
  end

end
