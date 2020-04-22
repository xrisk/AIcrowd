require 'rails_helper'

describe Export::CategoryChallengeSerializer, serializer: true do
  subject { described_class.new(category_challenge) }

  let(:category)           { create(:category, id: 2) }
  let(:category_challenge) { create(:category_challenge, category: category) }

  describe '#as_json' do
    it 'returns serialized category_challenge' do
      serialized_category_challenge = subject.as_json

      expect(serialized_category_challenge[:category_id]).to eq 2
    end
  end
end
