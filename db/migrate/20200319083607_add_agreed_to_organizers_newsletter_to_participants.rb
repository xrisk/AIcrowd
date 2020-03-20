class AddAgreedToOrganizersNewsletterToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :agreed_to_organizers_newsletter, :boolean, null: false, default: true
  end
end
