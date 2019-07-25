# frozen_string_literal: true
LetterOpener.configure do |config|
  config.location = Rails.root.join('tmp', 'letter_opener')
  config.message_template = :default
end
