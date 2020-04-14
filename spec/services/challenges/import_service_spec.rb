require 'rails_helper'

describe Challenges::ImportService do
  subject { described_class.new(import_params: import_params) }

  describe '#call' do
    let!(:first_organizer)  { create(:organizer, id: 1) }
    let!(:second_organizer) { create(:organizer, id: 2) }

    context 'when file with valid JSON and valid data provided' do
      let(:import_params) { ActionController::Parameters.new(JSON.parse(file_fixture('json/challenge_import.json').read)) }

      it 'return success and Challenge object' do
        result        = subject.call
        new_challenge = result.value

        expect(result.success?).to eq true
        expect(new_challenge.class).to eq Challenge
      end
    end

    context 'when file not provided' do
      let(:import_params) { nil }

      it 'return failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Import failed: There are no params to import'
      end
    end

    context 'when file with valid JSON and invalid data provided' do
      let(:import_params) { ActionController::Parameters.new(JSON.parse(file_fixture('json/challenge_import_with_errors.json').read)) }

      it 'return failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Import failed: Challenge can\'t be blank'
      end
    end
  end
end
