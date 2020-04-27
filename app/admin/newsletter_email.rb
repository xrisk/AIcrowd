ActiveAdmin.register NewsletterEmail do
  config.sort_order = :pending_desc

  actions :index, :show, :edit, :update

  permit_params :participant_id,
                :bcc,
                :cc,
                :subject,
                :message

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
    column :challenge
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
      f.input :participant
      f.input :bcc
      f.input :cc
      f.input :subject
      f.input :message, as: :ckeditor
    end

    div class: 'actions newsletter-emails__actions' do
      if resource.pending?
        a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm':  'Are you sure you want to send this e-mail to participants?', class: 'member_link newsletter-emails__button'
        a 'Decline', href: decline_admin_newsletter_email_path(resource), 'data-method': :delete, 'data-confirm': 'Are you sure you want to remove this e-mail?', class: 'member_link newsletter-emails__button'
      end
    end

    f.actions
  end


  member_action :approve, method: :post do
    Organizers::NewsletterEmailJob.perform_later(resource.id)
    resource.update!(pending: false)

    redirect_to admin_newsletter_emails_path, flash: { notice: 'Newsletter email has been sent to participants.' }
  end

  member_action :decline, method: :delete do
    resource.update!(pending: false, declined: true)

    redirect_to admin_newsletter_emails_path, flash: { notice: 'Newsletter email has been declined.' }
  end

  action_item :approve_newsletter_email, only: :show do
    a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm':  'Are you sure you want to send this e-mail to participants?', class: 'member_link'
  end

  action_item :decline_newsletter_email, only: :show do
    a 'Decline', href: decline_admin_newsletter_email_path(resource), 'data-method': :delete, 'data-confirm': 'Are you sure you want to decline this e-mail?', class: 'member_link'
  end
end
