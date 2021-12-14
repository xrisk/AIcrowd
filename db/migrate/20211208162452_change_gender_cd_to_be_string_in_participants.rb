class ChangeGenderCdToBeStringInParticipants < ActiveRecord::Migration[5.2]
  def change
    change_column :participants, :gender_cd, :string
  end
end
