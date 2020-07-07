class AddGitlabIdToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :gitlab_id, :bigint
  end
end
