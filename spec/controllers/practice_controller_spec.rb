require 'rails_helper'

describe PracticeController, type: :controller do
  render_views

  let!(:practice_challenge_1)   { create(:challenge, :completed, practice_flag: true) }
  let!(:practice_challenge_2)   { create(:challenge, :completed, practice_flag: true) }
  let!(:not_practice_challenge) { create(:challenge, :completed, practice_flag: false) }

  let(:participant) { create(:participant) }

  describe 'GET #index' do
    context 'public participant' do
      before { get :index }

      it { expect(assigns(:practice_challenges)).to contain_exactly(practice_challenge_1, practice_challenge_2) }
      it { expect(assigns(:practice_challenges)).not_to eq [not_practice_challenge] }
      it { expect(response).to render_template :index }
    end
  end
end
