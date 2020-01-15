require 'rails_helper'

describe ArticlesController, type: :controller do
  render_views

  let(:participant)        { create(:participant, admin: true) }
  let(:valid_attributes)   { FactoryBot.attributes_for(:article, participant_id: participant.id) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:article, :invalid) }

  context 'admin' do
    before { sign_in participant }

    describe 'GET #index' do
      let!(:articles) { create_list(:article, 3, participant: participant) }

      before { get :index }

      it { expect(assigns(:articles)).to eq articles.reverse }
      it { expect(response).to render_template :index }
    end

    describe 'GET #show' do
      let!(:article) { create(:article, participant: participant) }

      before { get :show, params: { id: article.id } }

      it { expect(assigns(:article)).to eq article }
      it { expect(response).to render_template :show }
    end

    describe "GET #new" do
      before { get :new }

      it { expect(assigns(:article)).to be_a_new(Article) }
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Article" do
          expect { post :create, params: { article: valid_attributes } }.to change(Article, :count).by(1)
        end

        it "assigns a newly created article as @article" do
          post :create, params: { article: valid_attributes }

          expect(assigns(:article)).to be_a(Article)
          expect(assigns(:article)).to be_persisted
        end

        it "creates a placeholder section" do
          post :create, params: { article: valid_attributes }

          expect(assigns(:article).article_sections.first.section).to eq('Intro')
        end

        it "redirects to the created article" do
          post :create, params: { article: valid_attributes }

          expect(response).to redirect_to(assigns(:article))
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved article as @article" do
          post :create, params: { article: invalid_attributes }

          expect(assigns(:article)).to be_a_new(Article)
        end

        it "re-renders the 'new' template" do
          post :create, params: { article: invalid_attributes }

          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      let!(:article) { create(:article, participant_id: participant.id) }

      context "with valid params" do
        let(:new_attributes) { { article: 'A new body of article text' } }

        it "updates the requested article" do
          put :update, params: { id: article.to_param, article: new_attributes }

          expect(article.reload.article).to eq(new_attributes[:article])
        end

        it "assigns the requested article as @article" do
          put :update, params: { id: article.to_param, article: valid_attributes }

          expect(assigns(:article)).to eq(article)
        end

        it "redirects to the article" do
          put :update, params: { id: article.to_param, article: valid_attributes }

          expect(response).to redirect_to(article.reload)
        end
      end

      context "with invalid params" do
        it "assigns the article as @article" do
          put :update, params: { id: article.to_param, article: invalid_attributes }

          expect(assigns(:article)).to eq(article)
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: article.to_param, article: invalid_attributes }

          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:article) { create(:article, participant: participant) }

      it "destroys the requested article" do
        expect { delete :destroy, params: { id: article.to_param } }.to change(Article, :count).by(-1)
      end

      it "redirects to the articles list" do
        delete :destroy, params: { id: article.to_param }

        expect(response).to redirect_to(articles_url)
      end
    end
  end
end
