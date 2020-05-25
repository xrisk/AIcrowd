class Category < ApplicationRecord
  has_many :category_challenges, dependent: :destroy
  has_many :challenges, through: :category_challenges

  validates :name, presence: true, format: { without: /#/, message: " => you can't add # in Tags" }
end
