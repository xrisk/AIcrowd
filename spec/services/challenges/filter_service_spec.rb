require 'rails_helper'

describe Challenges::FilterService do
  let!(:challenge1) { create(:challenge, status: 'running') }
  let!(:challenge2) { create(:challenge, status: 'completed') }
  subject { described_class.new(params, Challenge.all) }

  describe '#call' do
    let(:category) { create(:category) }
    let!(:category_challenge) { create(:category_challenge, challenge: challenge1, category: category) }
    let(:params) { ActionController::Parameters.new(category: { category_names: [category.name] }, status: 'running', prize: { prize_type: challenge1.prize_cash }) }

    context 'when categories name, status and prize cash are provided' do
      it 'return challenges as per given fields' do
        response = subject.call
        result   = response.first

        expect(result.categories.first.name).to eq challenge1.categories.first.name
        expect(result.prize_cash).to eq challenge1.prize_cash
        expect(result.status_cd).to eq challenge1.status_cd
      end
    end
  end
end
