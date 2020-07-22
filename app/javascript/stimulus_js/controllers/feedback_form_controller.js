import { Controller } from "stimulus"
import { showAlert } from '../helpers/alerts_helper'

export default class extends Controller {
  handleFormSubmit(event) {
    event.preventDefault();

    const requestURL           = this.data.get('create-feedback-url');
    const feedbackMessageField = document.querySelectorAll('#feedbackModal .cke_wysiwyg_div')[0];
    const feedbackMessageHTML  = feedbackMessageField.innerHTML;
    const feedbackMessageText  = feedbackMessageField.textContent;

    if (feedbackMessageText && feedbackMessageText.length) {
      fetch(requestURL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message: feedbackMessageHTML })
      }).then(response => {
        if (response.ok) {
          $('#feedbackModal').modal('hide');
          showAlert('success', 'Thank you for your feedback!');
        }
      })
    } else {
      showAlert('danger', 'Feedback must contain a message', 'feedback-form-alert-wrapper');
    }
  }
}
