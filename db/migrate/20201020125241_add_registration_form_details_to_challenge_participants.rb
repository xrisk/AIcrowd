class AddRegistrationFormDetailsToChallengeParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_participants, :registration_form_details, :jsonb
  end
end
