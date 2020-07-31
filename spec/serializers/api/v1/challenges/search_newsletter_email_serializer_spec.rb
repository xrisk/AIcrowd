require 'rails_helper'

describe Api::V1::Challenges::SearchNewsletterEmailsSerializer, serializer: true do
  subject do
    described_class.new(
      groups:           [{ id: :all_participants, text: 'All participants' }],
      teams:            [team],
      participants:     [first_participant, second_participant],
      challenge_rounds: [challenge_round]
    ).serialize
  end

  let(:first_participant)  { create(:participant, name: 'joe', email: 'joe@example.com') }
  let(:second_participant) { create(:participant, name: 'test', email: 'test@example.com') }
  let(:team)               { create(:team, name: 'example_team') }
  let(:challenge_round)    { create(:challenge_round) }

  describe '#serialize' do
    let(:expected_result) do
      {
        results:    [
          {
            text:     'Groups',
            children: [
              { id: :all_participants, text: 'All participants' },
              { id: "challenge_round_#{challenge_round.id}", text: 'Participants of "Round 1"' }
            ]
          },
          {
            text:     'Teams',
            children: [
              { id: '', text: 'example_team' }
            ]
          },
          {
            text:     'Users',
            children: [
              { id: 'joe@example.com', text: 'joe' },
              { id: 'test@example.com', text: 'test' }
            ]
          }
        ],
        processing: { more: false }
      }
    end

    it 'returns serialized participants' do
      expect(subject).to eq expected_result
    end
  end
end
