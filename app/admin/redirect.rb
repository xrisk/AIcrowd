ActiveAdmin.register Redirect do
  permit_params :redirect_url, :destination_url, :active
end
