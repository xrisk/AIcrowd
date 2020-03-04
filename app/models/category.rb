class Category < ApplicationRecord
  has_many :category_challenges, dependent: :destroy
  has_many :challenges, through: :category_challenges
end
