class PublicationAuthor < ApplicationRecord
  belongs_to :publication
  belongs_to :participant, optional: true
end
