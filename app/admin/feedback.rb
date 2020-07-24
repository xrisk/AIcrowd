ActiveAdmin.register Feedback do
  actions :index, :show, :edit, :update, :destroy
  permit_params :id, :message, :participant_id
end
