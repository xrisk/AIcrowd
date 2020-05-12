FactoryBot.define do
  factory :ahoy_visit, class: 'Ahoy::Visit' do
    started_at { Time.current }
    user       { create(:participant) }
  end
end
