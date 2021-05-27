class AddSuperAdminToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :super_admin, :boolean, default: false
  end
end
