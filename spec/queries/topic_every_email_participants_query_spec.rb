require 'rails_helper'

RSpec.describe TopicEveryEmailParticipantsQuery do
  describe 'receive every email' do
    context 'receive every email AND has hearted the challenge' do
      let!(:author) { create :participant }
      let!(:follower) { create :participant }
      let!(:email_preference1) do
        create :email_preference,
               email_frequency: :every,
               participant:     author
      end
      let!(:email_preference2) do
        create :email_preference,
               email_frequency: :every,
               participant:     follower
      end
      let!(:follow) { create :follow, participant: follower }
      let!(:topic) do
        create :topic,
               challenge_id: follow.followable_id,
               participant:  author
      end

      subject(:query) { described_class.new(topic.id).call }

      it { expect(query.sort).to match_array([follower.id].sort) }
    end
  end

  describe 'does not receive every email' do
    context 'receive daily digest AND has hearted the challenge' do
      let!(:author) { create :participant }
      let!(:follower) { create :participant }
      let!(:email_preference1) do
        create :email_preference,
               email_frequency: :daily,
               participant:     author
      end
      let!(:email_preference2) do
        create :email_preference,
               email_frequency: :daily,
               participant:     follower
      end
      let!(:follow) { create :follow, participant: follower }
      let!(:topic) do
        create :topic,
               challenge_id: follow.followable_id,
               participant:  author
      end

      subject(:query) { described_class.new(topic.id).call }

      it { expect(query.sort).to match_array([]) }
    end

    context 'receive weekly digest AND has hearted the challenge' do
      let!(:author) { create :participant }
      let!(:follower) { create :participant }
      let!(:email_preference1) do
        create :email_preference,
               email_frequency: :weekly,
               participant:     author
      end
      let!(:email_preference2) do
        create :email_preference,
               email_frequency: :weekly,
               participant:     follower
      end
      let!(:follow) { create :follow, participant: follower }
      let!(:topic) do
        create :topic,
               challenge_id: follow.followable_id,
               participant:  author
      end

      subject(:query) { described_class.new(topic.id).call }

      it { expect(query.sort).to match_array([]) }
    end
  end
end
