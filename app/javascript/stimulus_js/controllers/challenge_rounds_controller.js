import { Controller } from 'stimulus'
import { showAlert } from '../helpers/alerts_helper'
import { enableButton, disableButton } from '../helpers/buttons_helper'

export default class extends Controller {
  leaderboardNoteToogle(event) {
    const leaderboardToogle = event.target;
    $(leaderboardToogle).closest('label').hide();
    $(leaderboardToogle).closest('div').find('.leaderboard-text-area').removeClass('d-none');
  }

  removeChallengeRound(event) {
    event.preventDefault();

    const removeButton     = event.target;
    const requestURL       = this.data.get('remove-round-url');
    const challengeRoundId = this.data.get('challenge-round-id');
    const childIndex       = this.data.get('child-index');
    const roundWrapper     = document.getElementById(`challenge-round-wrapper-${challengeRoundId}`);
    const associationInput = document.getElementById(`challenge_challenge_rounds_attributes_${childIndex}_id`);

    disableButton(removeButton, 'Removing...');

    if (confirm('Are you sure you want to permanently remove this challenge round?')) {
      this.sendRemoveChallengeRoundRequest(requestURL, roundWrapper, associationInput)
    }

    enableButton(removeButton, 'Remove Round');
  }

  sendRemoveChallengeRoundRequest(requestURL, roundWrapper, associationInput) {
    fetch(requestURL, {
      method: 'DELETE',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    }).then(response => {
      if (response.ok) {
        showAlert('success', 'Challenge round was removed');

        roundWrapper.remove();
        associationInput.remove();
      } else {
        return response.json();
      }
    })
    .then((result) => {
      if (result && result.error) {
        showAlert('danger', result.error);
      }
    })
    .catch((error) => {
      console.error('Error:', error);
    });
  }

  onboardingTour(event) {
    console.log("To be implemented");
    return;

    //initialize instance
    var enjoyhint_instance = new EnjoyHint({});

    var enjoyhint_script_steps = [
      {
        'next .score-title': 'Hey!'
      }  
    ];

    //set script config
    enjoyhint_instance.set(enjoyhint_script_steps);

    //run Enjoyhint script
    enjoyhint_instance.run();
  }
}
