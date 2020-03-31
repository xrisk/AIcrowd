class EmailsListValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors[attribute] << (options[:message] || 'must be a list of valid e-mails that are separated by commas') unless emails_list_valid?(value)
  end

  private

  def emails_list_valid?(emails_list)
    emails_list.split(',').all? { |email| email_valid?(email.strip) }
  end

  def email_valid?(email)
    # Use Devise email regexp as it's trusted and widely used in Ruby community for e-mail validation.
    ::Devise.email_regexp =~ email
  end
end
