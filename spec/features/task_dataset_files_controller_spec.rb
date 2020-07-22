require 'rails_helper'

describe TaskDatasetFilesController do
  let!(:clef_task)          { create(:clef_task) }
  let!(:challenge)          { create(:challenge, :running, clef_task: clef_task) }
  let!(:task_dataset_files) { create_list(:task_dataset_file, 2, description: 'Task Dataset File Description', clef_task: clef_task) }

  describe '#index' do
    context 'when visited by admin' do
      let(:admin) { create(:participant, :admin, first_name: 'Peter', last_name: 'Parker') }

      before { login_as admin }

      it 'render task dataset files listing' do
        visit clef_task_task_dataset_files_path(clef_task_id: clef_task.id, challenge_id: challenge.id)

        click_on 'Agree'

        expect(page).to have_http_status 200
        expect(page).to have_current_path clef_task_task_dataset_files_path(clef_task_id: clef_task.id, challenge_id: challenge.id)
        expect(page).to have_content 'Task Dataset File Description'
      end
    end
  end
end
