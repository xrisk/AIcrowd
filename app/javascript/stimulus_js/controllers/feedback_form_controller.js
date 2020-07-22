import { Controller } from "stimulus"

export default class extends Controller {
  handleFormSubmit(event) {
    event.preventDefault();

    const requestURL      = '';
    const feedbackMessage = '';

    if (feedbackMessage && feedbackMessage.length) {
      fetch(requestURL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ feedback_message: feedbackMessage })
      }).then(response => {

      })
    } else {

    }
  }
}
