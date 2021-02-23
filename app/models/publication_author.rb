class PublicationAuthor < ApplicationRecord
  belongs_to :publication
  belongs_to :participant, optional: true
  default_scope { order(:sequence) }
end
