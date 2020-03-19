ActiveAdmin.register NewsletterEmail do
  actions :index, :show, :new, :create
  permit_params :emails_list, :cc, :subject, :message

  index do
    column :id
    column :emails_list
    column :cc
    column :subject
    column :message
    column :pending
    column :created_at
    column :updated_at
    actions default: true do |resource|
      if resource.pending?
        a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm':  'Are you sure you want to send this e-mail to participants?', class: 'member_link'
        a 'Decline', href: decline_admin_newsletter_email_path(resource), 'data-method': :delete, 'data-confirm': 'Are you sure you want to remove this e-mail?', class: 'member_link'
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :emails_list, as: :string
      f.input :cc, as: :string
      f.input :subject, as: :string
      f.input :message
    end
    f.actions
  end

  member_action :approve, method: :post do
    # TODO: Implement business logic in next Pull Request
    resource.update!(pending: false)

    redirect_to admin_newsletter_emails_path, flash: { notice: 'Newsletter email has been sent to participants.' }
  end

  member_action :decline, method: :delete do
    resource.destroy!

    redirect_to admin_newsletter_emails_path, flash: { notice: 'Newsletter email has been removed.' }
  end

  action_item :approve_newsletter_email, only: :show do
    a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm':  'Are you sure you want to send this e-mail to participants?', class: 'member_link'
  end

  action_item :decline_newsletter_email, only: :show do
    a 'Decline', href: decline_admin_newsletter_email_path(resource), 'data-method': :delete, 'data-confirm': 'Are you sure you want to remove this e-mail?', class: 'member_link'
  end
end
