class Category < ApplicationRecord
  has_many :category_challenges
  has_many :challenges, through: :category_challenges
end
