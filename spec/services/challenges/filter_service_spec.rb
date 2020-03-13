require 'rails_helper'

describe Challenges::FilterService do

  describe '#call' do
    let(:challenge1) { create(:challenge) }
    let(:challenge2) { create(:challenge) }
    let(:category) { create(:category) }
    let(:category_challenge) { create(:category_challenge, challenge: challenge1, category: category) }
    let(:params) { create(:category_challenge, challenge: challenge1, category: category) }

    context 'when categories name, status and prize cash are provided' do
      it 'return challenges as per given fields' do
        params = ActionController::Parameters.new(category: { category_names: [category.name] }, status: challenge1.status_cd, prize: { prize_type: challenge1.prize_cash })
        challenge1
        challenge2
        category_challenge
        subject = described_class.new(params, Challenge.all)
        result  = subject.call
        expect(result.first).to eq challenge1
        expect(result.count).to eq 1
      end
    end
  end
end
