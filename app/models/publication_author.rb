class PublicationAuthor < ApplicationRecord
  has_and_belongs_to_many :publications
  belongs_to :participant, optional: true
  default_scope { order(:sequence) }
end
