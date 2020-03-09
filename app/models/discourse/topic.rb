module Discourse
  class Topic < ApplicationRecord
    belongs_to :discourse_category, class_name: 'Discourse::Category'
    belings_to :participant, class_name 'Participant'

    validates :title, presence: true
  end
end
