FactoryBot.define do
  factory :migration_mapping, class: 'MigrationMapping' do
    crowdai_participant_id { 1 }

    association(:source, factory: :submission)
  end
end
