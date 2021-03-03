class PublicationExternalLink < ApplicationRecord
  belongs_to :publication, optional: true
end
