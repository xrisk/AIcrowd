require 'rails_helper'

describe Challenges::ImportService do
  subject { described_class.new(import_file: import_file, organizers: [organizer]) }

  describe '#call' do
    let(:organizer) { create(:organizer) }

    context 'when file with valid JSON and valid data provided' do
      let(:import_file) { file_fixture('json/challenge_import.json') }

      it 'return success and Challenge object' do
        result        = subject.call
        new_challenge = result.value

        expect(result.success?).to eq true
        expect(new_challenge.class).to eq Challenge
      end
    end

    context 'when file not provided' do
      let(:import_file) { nil }

      it 'return failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Import failed: File not selected'
      end
    end

    context 'when file with valid JSON and invalid data provided' do
      let(:import_file) { file_fixture('json/challenge_import_with_errors.json') }

      it 'return failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq 'Import failed: Challenge can\'t be blank'
      end
    end

    context 'when file with invalid JSON provided' do
      let(:import_file) { file_fixture('json/challenge_import_with_invalid_json.json') }

      it 'returns failure and error message' do
        result = subject.call

        expect(result.success?).to eq false
        expect(result.value).to eq "Import failed: 822: unexpected token at 'INVALID_JSON\n'"
      end
    end
  end
end
