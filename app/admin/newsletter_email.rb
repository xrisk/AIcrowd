ActiveAdmin.register NewsletterEmail do
  config.sort_order = :pending_desc

  actions :index, :show

  index do
    column :id
    column :to do |resource|
      resource.participant&.email
    end
    column :bcc
    column :cc
    column :subject
    column :message
    column :pending
    column :participant
    column :created_at
    column :updated_at
    actions default: true do |resource|
      if resource.pending?
        a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm':  'Are you sure you want to send this e-mail to participants?', class: 'member_link'
        a 'Decline', href: decline_admin_newsletter_email_path(resource), 'data-method': :delete, 'data-confirm': 'Are you sure you want to remove this e-mail?', class: 'member_link'
      end
    end
  end

  member_action :approve, method: :post do
    Organizers::NewsletterEmailJob.perform_later(resource.id)
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
