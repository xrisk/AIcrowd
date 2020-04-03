import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['subject']

  preview(event) {
    event.preventDefault();

    const previewButton          = event.target;
    const requestURL             = this.data.get('preview-url');
    const newsletterEmailMessage = document.querySelectorAll('#newsletter-email-message-wrapper .ck-content')[0].innerHTML;
    const requestBody            = { newsletter_email: { subject: this.subjectTarget.value, message: newsletterEmailMessage } };

    this.disablePreviewButton(previewButton);

    fetch(requestURL, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestBody)
    }).then(response => {
      this.enablePreviewButton(previewButton);

      if (response.ok) {
        this.showAlert('success', 'Preview e-mail was sent to your mailbox');
      } else {
        $('#newsletter_email_form_subject').trigger('focusout');
      }
    });
  }

  disablePreviewButton(button) {
    button.disabled    = true;
    button.textContent = 'Sending Preview E-mail...';
  }

  enablePreviewButton(button) {
    button.removeAttribute('disabled');
    button.textContent = 'Preview';
  }

  showAlert(alertType, alertMessage) {
    const alertWrapper = document.getElementById('flash-messages-wrapper');

    alertWrapper.innerHTML = this.alertTemplate(alertType, alertMessage);
    window.scrollTo(0, 0);
  }

  alertTemplate(alertType, alertMessage) {
    return `<div class="alert alert-${alertType} alert-dismissible fade show flash-message" role="alert">
              <div class="container-fluid">
                <center>${alertMessage}</center>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
            </div>`;
  }
}
