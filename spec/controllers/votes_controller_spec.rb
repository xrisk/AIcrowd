require 'rails_helper'

describe VotesController, type: :controller do
  render_views

  let!(:challenge)   { create(:challenge) }
  let!(:article)     { create(:article) }
  let!(:topic)       { create(:topic) }
  let!(:participant) { create(:participant) }

  context 'participant' do
    before { sign_in participant }

    describe "POST #create for Challenge" do
      def register_vote
        post :create, params: { challenge_id: challenge.id }
        challenge.reload
      end

      it { expect { register_vote }.to change(Vote, :count).by(1) }
      it { expect { register_vote }.to change(challenge, :vote_count).by(1) }
    end

    describe "POST #create for Article" do
      def register_vote
        post :create, params: { article_id: article.id }
        article.reload
      end

      it { expect { register_vote }.to change(Vote, :count).by(1) }
      it { expect { register_vote }.to change(article, :vote_count).by(1) }
    end

    describe "POST #create for Topic" do
      def register_vote
        post :create, params: { topic_id: topic.id }
        topic.reload
      end

      it { expect { register_vote }.to change(Vote, :count).by(1) }
      it { expect { register_vote }.to change(topic, :vote_count).by(1) }
    end
  end
end
