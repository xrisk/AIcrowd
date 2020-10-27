class AddRegistrationFormFieldsToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :registration_form_fields, :string
  end
end
