import { Controller } from "stimulus"
import { showAlert } from '../helpers/alerts_helper'
import { enableButton, disableButton } from '../helpers/buttons_helper'

export default class extends Controller {
  static targets = ['subject']

  preview(event) {
    event.preventDefault();

    const previewButton          = event.target;
    const requestURL             = this.data.get('preview-url');
    const newsletterEmailMessage = document.querySelectorAll('#newsletter-email-message-wrapper .ck-content')[0].innerHTML;
    const requestBody            = { newsletter_email: { subject: this.subjectTarget.value, message: newsletterEmailMessage } };

    disableButton(previewButton, 'Sending Preview E-mail...');

    fetch(requestURL, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestBody)
    }).then(response => {
      if (response.ok) {
        showAlert('success', 'Preview e-mail was sent to your mailbox');
      } else {
        $('#newsletter_email_form_subject').trigger('focusout');
      }
    });

    enableButton(previewButton, 'Preview');
  }
}
