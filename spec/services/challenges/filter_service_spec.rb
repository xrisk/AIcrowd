require 'rails_helper'

describe Challenges::FilterService do
  subject { described_class.new(params, Challenge.all) }

  describe '#call' do
    let!(:challenge1) { create(:challenge) }
    let!(:challenge2) { create(:challenge) }
    let(:category) { create(:category) }
    let!(:category_challenge) { create(:category_challenge, challenge: challenge1, category: category) }
    let(:params) { ActionController::Parameters.new(category: { category_names: [category.name] }, status: challenge1.status_cd, prize: { prize_type: challenge1.prize_cash }) }

    context 'when categories name, status and prize cash are provided' do
      it 'return challenges as per given fields' do
        result = subject.call
        expect(result.first).to eq challenge1
      end
    end
  end
end
