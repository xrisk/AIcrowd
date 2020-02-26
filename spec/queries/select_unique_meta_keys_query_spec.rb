require 'rails_helper'

describe SelectUniqueMetaKeysQuery, type: :query do
  subject { described_class.new.call }

  describe '#call' do
    let!(:first_leaderboard)  { create(:base_leaderboard, meta: { first_key: 'first_key', second_key: 'second_key' }) }
    let!(:second_leaderboard) { create(:base_leaderboard, meta: { second_key: 'second_key' }) }

    it 'returns collection of unique meta keys' do
      expect(subject).to eq ['first_key', 'second_key']
    end
  end
end
