class JobPosting < ApplicationRecord
  include Markdownable
  include FriendlyId

  default_scope { order('created_at DESC') }

  validates_presence_of :title
  validates_presence_of :organisation
  validates_presence_of :description_markdown
  validates_presence_of :country
  validates_presence_of :posting_date

  friendly_id :title, use: [:slugged]
  as_enum :status, [:draft, :open, :closed], map: :string

  def country_name
    c = ISO3166::Country[country]
    c.translations[I18n.locale.to_s] || c.name
  end

  def record_page_view
    self.page_views ||= 0
    self.page_views += 1
    self.save
  end

end
