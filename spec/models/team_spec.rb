require 'rails_helper'

describe Team do
  let!(:team) { create :team }
  context 'concreteness' do
    describe 'false with 0 participants' do
      it { expect(team.team_participants.count).to eq(0)  }
      it { expect(team.concrete?).not_to be }
    end

    describe 'false with 1 participants' do
      let!(:p1) { create :participant }
      before do
        team.team_participants.create(participant: p1, role: :organizer)
      end
      it { expect(team.team_participants.count).to eq(1)  }
      it { expect(team.concrete?).not_to be }
    end

    describe 'true with 2 participants' do
      let!(:p1) { create :participant }
      let!(:p2) { create :participant }
      before do
        team.team_participants.create(participant: p1, role: :organizer)
        team.team_participants.create(participant: p2, role: :member)
      end
      it { expect(team.team_participants.count).to eq(2)  }
      it { expect(team.concrete?).to be }
    end
  end
end
