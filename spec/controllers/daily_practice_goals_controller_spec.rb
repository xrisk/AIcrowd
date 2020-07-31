require 'rails_helper'

describe DailyPracticeGoalsController, type: :controller do
  render_views

  let!(:participant) { create(:participant) }
  let!(:challenge) { create(:challenge) }
  let!(:daily_practice_goal_1) { create(:daily_practice_goal) }
  let!(:daily_practice_goal_2) { create(:daily_practice_goal, title: 'Regular', points: 200, duration_text: '3 Months approx') }

  context 'participant' do
    before do
      sign_in participant
    end

    describe 'GET #index' do
      context 'Daily Practice Goal' do
        before do
          get :index, params: { challenge_id: challenge.id }
        end

        it { expect(assigns(:goals)).to contain_exactly(daily_practice_goal_1, daily_practice_goal_2) }
        it { expect(response).to render_template :index }
      end
    end
  end
end
