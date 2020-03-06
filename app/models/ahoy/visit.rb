class Ahoy::Visit < ApplicationRecord
  self.table_name = 'ahoy_visits'
  self.primary_key = :id
  has_many :events, class_name: 'Ahoy::Event'
  belongs_to :user, optional: true, class_name: 'Participant'
end
