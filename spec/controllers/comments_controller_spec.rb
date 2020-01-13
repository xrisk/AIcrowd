require 'rails_helper'

describe CommentsController, type: :controller do
  render_views

  let!(:topic)       { create(:topic) }
  let!(:participant) { create(:participant) }

  let(:valid_attributes) { { comment_markdown: "### This is a comment" } }

  context 'participant' do
    before { sign_in participant }

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Comment" do
          expect do
            post :create, params: { topic_id: topic.id, comment: valid_attributes }
          end.to change(Comment, :count).by(1)
        end
      end

      context "queues EveryCommentNotificationJob" do
        it "creates a new Comment" do
          expect do
            post :create, params: { topic_id: topic.id, comment: valid_attributes }
          end.to have_enqueued_job(EveryCommentNotificationJob)
        end
      end
    end

    describe 'POST #create: mentions creates notifications' do
      let(:mentionable) { create :participant, name: 'Sean' }
      let(:valid_attributes) do
        {
          comment_markdown: "hello @Sean",
          mentions_cache:   "[{\"id\":1,\"name\":\"Sean\"},{\"id\":22,\"name\":\"Hanno\"}]"
        }
      end

      it 'queues MentionsNotificationsJob' do
        expect do
          post :create, params: { topic_id: topic.id, comment: valid_attributes }
        end.to have_enqueued_job(MentionsNotificationsJob)
      end
    end
  end

  context 'public user' do
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Comment" do
          post :create, params: { topic_id: topic.id, comment: valid_attributes }
          expect(response).to redirect_to(new_participant_session_path)
        end
      end
    end
  end
end
