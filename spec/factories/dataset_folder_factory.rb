FactoryBot.define do
  factory :dataset_folder, class: 'DatasetFolder' do
    title          { 'Folder Title' }
    description    { FFaker::Lorem.sentence(3) }
    directory_path { 'folder_name' }
    aws_access_key { 'REDACTED' }
    aws_secret_key { 'REDACTED' }
    bucket_name    { 'bucket_name' }
    region         { 'eu-north-1' }
    visible        { true }
    evaluation     { false }

    association(:challenge)
  end
end
