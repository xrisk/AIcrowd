import { Controller } from "stimulus"
import { showAlert } from '../helpers/alerts_helper'

export default class extends Controller {
  handleFormSubmit(event) {
    event.preventDefault();

    const requestURL       = this.data.get('create-feedback-url');
    const feedbackTextarea = document.getElementById('feedback-form-message');
    const feedbackMessage  = feedbackTextarea.value;

    if (feedbackMessage && feedbackMessage.length) {
      fetch(requestURL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message: feedbackMessage })
      }).then(response => {
        if (response.ok) {
          feedbackTextarea.value = '';
          $('#feedbackModal').modal('hide');
          showAlert('success', 'Thank you for your feedback!');
        }
      })
    } else {
      showAlert('danger', 'Feedback must contain a message', 'feedback-form-alert-wrapper');
    }
  }
}
