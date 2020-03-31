require 'rails_helper'

class EmailsListValidatorDouble
  include ActiveModel::Validations

  attr_accessor :emails_list_string

  validates :emails_list_string, emails_list: true

  def initialize(emails_list_string:)
    @emails_list_string = emails_list_string
  end
end

describe EmailsListValidator do
  describe '#validate_each' do
    context 'when value is blank' do
      let(:emails_list_validation_double) { EmailsListValidatorDouble.new(emails_list_string: '') }

      it 'returns true on validation' do
        expect(emails_list_validation_double).to be_valid
      end
    end

    context 'when value is a valid single e-mail' do
      let(:emails_list_validation_double) { EmailsListValidatorDouble.new(emails_list_string: 'peter@example.com') }

      it 'returns true on validation' do
        expect(emails_list_validation_double).to be_valid
      end
    end

    context 'when value is a list of valid multiple e-mails' do
      let(:emails_list_validation_double) { EmailsListValidatorDouble.new(emails_list_string: 'jhon@example.com, paul@example.com, mike@example.com') }

      it 'returns true on validation' do
        expect(emails_list_validation_double).to be_valid
      end
    end

    context 'when value is a list of valid multiple e-mails with extra white spaces' do
      let(:emails_list_validation_double) { EmailsListValidatorDouble.new(emails_list_string: '  jhon@example.com,    paul@example.com    , mike@example.com   ') }

      it 'returns true on validation' do
        expect(emails_list_validation_double).to be_valid
      end
    end

    context 'when value is a invalid e-mail' do
      let(:emails_list_validation_double) { EmailsListValidatorDouble.new(emails_list_string: 'INVALID_EMAIL') }

      it 'returns false on validation' do
        expect(emails_list_validation_double).not_to be_valid
      end
    end

    context 'when value is a list with signle invalid e-mail' do
      let(:emails_list_validation_double) { EmailsListValidatorDouble.new(emails_list_string: 'jhon@example.com, INVALID_EMAIL, mike@example.com') }

      it 'returns false on validation' do
        expect(emails_list_validation_double).not_to be_valid
      end
    end
  end
end
