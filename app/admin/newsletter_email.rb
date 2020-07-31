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
    column :decline_reason
    column :participant
    column :challenge
    column :created_at
    column :updated_at
    actions default: true do |resource|
      if resource.pending?
        a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm': 'Are you sure you want to send this e-mail to participants?', class: 'member_link'
        a 'Decline', href: '#', 'data-request-url': decline_admin_newsletter_email_url(resource), class: 'member_link newsletter-emails__decline-button'
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
        a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm': 'Are you sure you want to send this e-mail to participants?', class: 'member_link newsletter-emails__button'
        a 'Decline', href: '#', 'data-request-url': decline_admin_newsletter_email_url(resource), class: 'member_link newsletter-emails__decline-button'
      end
    end

    f.actions
  end

  member_action :approve, method: :post do
    NewsletterEmailsMailer.organizer_email(resource).deliver_later
    resource.update!(pending: false)

    redirect_to admin_newsletter_emails_path, flash: { notice: 'Newsletter email has been sent to participants.' }
  end

  member_action :decline, method: :post do
    resource.update!(pending: false, decline_reason: params[:decline_reason])

    NewsletterEmailsMailer.declined_email(resource).deliver_later

    redirect_to admin_newsletter_emails_path, flash: { notice: 'Newsletter email has been declined.' }
  end

  action_item :approve_newsletter_email, only: :show do
    a 'Approve', href: approve_admin_newsletter_email_path(resource), 'data-method': :post, 'data-confirm': 'Are you sure you want to send this e-mail to participants?', class: 'member_link'
  end

  action_item :decline_newsletter_email, only: :show do
    a 'Decline', href: '#', 'data-request-url': decline_admin_newsletter_email_url(resource), class: 'member_link newsletter-emails__decline-button'
  end
end
