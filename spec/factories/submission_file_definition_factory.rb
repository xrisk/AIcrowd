FactoryBot.define do
  factory :submission_file_definition, class: 'SubmissionFileDefinition' do
    seq                         { 1 }
    submission_file_description { 'Submission File Description' }
    filetype_cd                 { :txt }
    file_required               { false }
    submission_file_help_text   { 'Submission File Help Text' }

    association(:challenge)
  end
end
