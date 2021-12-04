class AddColumnGenderToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :gender_cd, :integer
  end
end
