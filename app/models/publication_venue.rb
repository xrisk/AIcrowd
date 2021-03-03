class PublicationVenue < ApplicationRecord
  belongs_to :publication, optional: true
end
