module Discourse
  class Category < ApplicationRecord
    validates :name, presence: true, unqiueness: true
  end
end
