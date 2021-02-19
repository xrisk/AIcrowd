class Category < ApplicationRecord
  has_many :category_challenges, dependent: :destroy
  has_many :challenges, through: :category_challenges
  has_many :category_posts, dependent: :destroy
  has_many :posts, through: :category_posts
  has_many :category_publications, dependent: :destroy
  has_many :publications, through: :category_publications

  validates :name, presence: true, format: { without: /#/, message: " => you can't add # in Tags" }
end
