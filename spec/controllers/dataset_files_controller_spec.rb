require 'rails_helper'

RSpec.describe DatasetFilesController, type: :controller do
  render_views

  let!(:challenge) { create :challenge, :running }
  let!(:challenge_rules) do
    create :challenge_rules,
           challenge: challenge
  end
  let!(:participation_terms) do
    create :participation_terms
  end
  let!(:file1) do
    create :dataset_file, challenge: challenge, title: 'file1'
  end
  let!(:file2) do
    create :dataset_file, challenge: challenge, title: 'file2'
  end
  let!(:participant) { create :participant }
  let!(:challenge_participant) do
    create :challenge_participant,
           challenge:   challenge,
           participant: participant
  end

  context 'participant' do
    before do
      sign_in participant
    end

    describe 'GET #index' do
      before { get :index, params: { challenge_id: challenge.id } }
      # =>   it { expect(assigns(:dataset_files).sort).to eq [first_file, file1, file2].sort }

      it { expect(response).to render_template :index }
    end

    describe "GET #new" do
      it "assigns a new dataset_file as @dataset_file" do
        get :new, params: { challenge_id: challenge.id }
        expect(assigns(:dataset_file)).to be_a_new(DatasetFile)
      end
    end

    describe "DELETE #destroy" do
      def delete_file
        delete :destroy, params: { challenge_id: challenge.id, id: file1.id }
      end

      #    it { expect { delete_file }.to change { DatasetFile.count }.by -1 }
      #    it { expect(response).to redirect_to(challenge_dataset_files_path(challenge)) }
      #    it { expect(flash[:notice]).to match "Dataset file #{file1.title} was deleted." }
    end
  end
end
