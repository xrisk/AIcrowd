require 'rails_helper'

describe SearchesController do
  describe '#show' do
    context 'when querying for challenges' do
      let!(:first_challenge)  { create(:challenge, :running, challenge: 'First Challenge') }
      let!(:second_challenge) { create(:challenge, :running, challenge: 'Second Challenge') }
      let!(:third_challenge)  { create(:challenge, challenge: 'First Not Running Challenge') }

      it 'renders matching challenges' do
        visit search_path(q: 'first', type: 'challenges')

        expect(page).to have_http_status :ok
        expect(page).to have_current_path search_path(q: 'first', type: 'challenges')
        expect(page).to have_content 'First Challenge'
        expect(page).not_to have_content 'Second Challenge'
        expect(page).not_to have_content 'First Not Running Challenge'
      end
    end

    context 'when querying for users' do
      let!(:first_participant)  { create(:participant, name: 'first_username') }
      let!(:second_participant) { create(:participant, name: 'second_username') }

      it 'renders matching users' do
        visit search_path(q: 'first', type: 'users')

        expect(page).to have_http_status :ok
        expect(page).to have_current_path search_path(q: 'first', type: 'users')
        expect(page).to have_content 'first_username'
        expect(page).not_to have_content 'second_username'
      end
    end
  end
end
