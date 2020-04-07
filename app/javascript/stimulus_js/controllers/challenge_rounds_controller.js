import { Controller } from "stimulus"

export default class extends Controller {
  removeChallengeRound(event) {
    event.preventDefault();

    const removeButton     = event.target;
    const requestURL       = this.data.get('remove-round-url');
    const challengeRoundId = this.data.get('challenge-round-id');
    const childIndex       = this.data.get('child-index');
    const roundWrapper     = document.getElementById(`challenge-round-wrapper-${challengeRoundId}`);
    const associationInput = document.getElementById(`challenge_challenge_rounds_attributes_${childIndex}_id`);

    this.disablePreviewButton(removeButton);

    if (confirm('Are you sure you want to permanently remove this challenge round?')) {
      fetch(requestURL, {
        method: 'DELETE',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      }).then(response => {
        if (response.ok) {
          this.showAlert('success', 'Challenge round was removed');

          roundWrapper.remove();
          associationInput.remove();
        } else {
          return response.json();
        }
      })
      .then((result) => {
        if (result && result.error) {
          this.showAlert('danger', result.error);
        }
      })
      .catch((error) => {
        console.error('Error:', error);
      });
    }

    this.enablePreviewButton(removeButton);
  }

  disablePreviewButton(button) {
    button.disabled    = true;
    button.textContent = 'Removing...';
  }

  enablePreviewButton(button) {
    button.removeAttribute('disabled');
    button.textContent = 'Remove Round';
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
