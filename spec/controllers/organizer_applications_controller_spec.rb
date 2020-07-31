require 'rails_helper'

describe OrganizerApplicationsController, type: :controller do
  render_views

  let!(:admin)           { create(:participant, :admin) }
  let(:valid_attributes) { FactoryBot.attributes_for(:organizer_application) }

  describe 'POST #create' do
    it 'creates a new OrganizerApplication' do
      expect do
        post :create, params: { organizer_application: valid_attributes }, format: :js
      end.to change(OrganizerApplication, :count).by(1)
    end

    it 'queues Admins::OrganizerApplicationNotificationJob job' do
      expect do
        post :create, params: { organizer_application: valid_attributes }, format: :js
      end.to have_enqueued_job(Admins::OrganizerApplicationNotificationJob)
    end

    it 'queues Organizers::NotificationsMailer email' do
      expect do
        post :create, params: { organizer_application: valid_attributes }, format: :js
      end.to have_enqueued_mail(Organizers::NotificationsMailer, :received_application_email)
    end
  end
end
