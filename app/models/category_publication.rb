class CategoryPublication < ApplicationRecord
  belongs_to :category
  belongs_to :publication
  validates :publication_id, uniqueness: { scope: :category_id }
end
