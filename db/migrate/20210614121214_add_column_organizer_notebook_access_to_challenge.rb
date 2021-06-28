class AddColumnOrganizerNotebookAccessToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :organizer_notebook_access, :boolean, default: false
  end
end
