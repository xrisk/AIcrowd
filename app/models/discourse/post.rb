module Discourse
  class Post < ApplicationRecord
    belongs_to :discourse_topic, class_name: 'Discourse::Topic'
    belings_to :participant, class_name 'Participant'

    validates :name, presence: true
  end
end
