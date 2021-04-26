ActiveAdmin.register Baseline do
  permit_params(:id, :git_url, :challenge_id)
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :git_url
      f.input :challenge_id
    end
    f.actions
  end
end
